public class Practice4BuyPageController {
    public Product_Table__c prod;
    public String prodId;
    public String email {get; set;}
    public String firstName {get; set;}
    public String lastName {get; set;}
    public Integer quant {get; set;}
    public Double amount {get; set;}
    public Id contId; 
    public boolean showButton {get; set;}
   
    public Practice4BuyPageController() { 
        if (ApexPages.currentPage().getParameters().get('Id') != null) {
            prodId = ApexPages.currentPage().getParameters().get('Id');
            prod = [SELECT Name, Image__c, Product_description__c, 
                	Unit_price__c, Units_available__c,
                    Warehouse__r.Name
                	FROM Product_Table__c WHERE Id = : prodId];
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Product query error'));
        }
        quant = 0;
        amount = 0;
        email = '';
        firstName = '';
        lastName = '';
    }
    
    public Product_Table__c getProd() {
        return prod;
    }
    
	public PageReference detailsPage() {
        PageReference pageRef = new PageReference(Page.Practice4DetailPage.getUrl());
        pageRef.getParameters().put('id', prodId);
        pageRef.setRedirect(true);
		return pageRef;
    }
    
    public void getCont() {
         if (email != null) {
            List<Contact> queryCont = [SELECT FirstName, LastName FROM Contact WHERE Email =: email LIMIT 1];
             if (!queryCont.isEmpty()) {
                contId = queryCont[0].Id;
                firstName = queryCont[0].FirstName;        
            	lastName = queryCont[0].LastName;
             }        
            checkQuant();
         }  
    }
    
    public void checkQuant() {
        amount = prod.Unit_price__c * quant;
        if (prod.Units_available__c >= quant &&
           	email.length() > 0 && 
            lastName.length() > 0 &&
           	quant > 0) { 
            showButton = true;
        } else {       
            showButton = false;
        }
    }
    
    public PageReference makeOrder() {
        if (contId == null) {
            Contact newCont = new Contact(
            LastName = lastName,
            Email = email
            );
            if (firstName.length() > 0) {
                newCont.FirstName = firstName;
            }
            try {
            insert newCont;
            } catch(DmlException e) { 
            	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getDmlMessage(0)));
                return null;
            }
            contId = newCont.Id;
        }
        Order_table__c newOrder = new Order_table__c(
        	Product_Table__c = prod.Id,
            Units__c = quant,
            Contact__c = contId,
            Order_Amount__c = amount
        );
        try {
            prod.Units_Available__c -= quant;
        	update prod;
        	insert newOrder;
        	PageReference pageRef = new PageReference(Page.Practice4MainPage.getUrl());
        	pageRef.getParameters().put('info', Label.orderSubmitted );
        	pageRef.setRedirect(true);
			return pageRef;       
        } catch(DmlException e) { 
            PageReference pageRef = new PageReference(Page.Practice4MainPage.getUrl());
        	pageRef.getParameters().put('info', Label.wentWrong + e.getMessage());
        	pageRef.setRedirect(true);
			return pageRef;                   
        }        
    }   
}