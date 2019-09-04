public class ProductTableTriggerHandler {
    public static void assignProduct(List<Product_Table__c> prod) {
        List<Warehouse__c> warehouses = selectWarehouse(prod);
        fillWarehouseField(prod, warehouses);
        createNewWarehouses(prod); 
    }
    
    private static void fillWarehouseField(List<Product_Table__c> prod, List<Warehouse__c> warehouses) {
        if (!warehouses.isEmpty()) {
            Map<Id, Date> startTimes = new Map<Id, Date>();
            for (Warehouse__c wh : warehouses) {
                startTimes.put(wh.Id, wh.Period_Start__c);
            }          
            Map<Id, Date> endTimes = new Map<Id, Date>();
            for (Warehouse__c wh : warehouses) {
                endTimes.put(wh.Id, wh.Period_End__c);
            }        
            for (Product_Table__c p : prod) {
                for (Id i : startTimes.keyset()) {
                    if (p.Added_Date__c >= startTimes.get(i)) {
                        if (p.Added_Date__c <= endTimes.get(i)) {
                        	p.Warehouse__c = i;
                    	}
                    }
                }
            }       
        }
    }
    
    private static void createNewWarehouses(List<Product_Table__c> prod) {
        Map<Date, Id> processedDate = new Map<Date, Id>();
         for (Product_Table__c p : prod) {
            if (p.Warehouse__c == null) {
                if (processedDate.keyset().contains(p.Added_Date__c)) {
                    p.Warehouse__c = processedDate.get(p.Added_Date__c);
                } else {
                    Decimal mc = Org_Configuration__c.getOrgDefaults().Period_Term__c;
                    Warehouse__c newWarehouse = new Warehouse__c();
                    newWarehouse.Name = 'Warehouse' + p.Added_Date__c + ' ' + mc;
                    newWarehouse.Period_Start__c = p.Added_Date__c;
                    newWarehouse.Period_End__c = p.Added_Date__c + (Integer)mc;
                    insert newWarehouse;
                    p.Warehouse__c = newWarehouse.Id;
                    processedDate.put(p.Added_Date__c, newWarehouse.Id);
                }              
            }
        }      
    }
    
    private static List<Warehouse__c> selectWarehouse(List<Product_Table__c> prod) {
        Date minDate = Date.today();
        Date maxDate = Date.today();      
        for (Product_Table__c p : prod) {
            if (p.Added_Date__c == null) {
                p.Added_Date__c = Date.today();
            }
            //if (p.Added_Date__c.day() < Date.today().day()) {
            //    p.Added_Date__c = Date.today();
            //}
            if (p.Added_Date__c < minDate) {
                minDate = p.Added_Date__c;
            }
            if (p.Added_Date__c > maxDate) {
                maxDate = p.Added_Date__c;
            }
        }       
       return [SELECT Id, Period_Start__c, Period_End__c 
               FROM Warehouse__c 
               WHERE Period_Start__c <= : minDate
               OR Period_End__c >= : maxDate
        	  ];
    }
}