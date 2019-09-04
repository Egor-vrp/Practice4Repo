public class Practice4DetailPageController {
    public Product_Table__c prod;
    public String prodId;
          
	public Practice4DetailPageController() {      
        if (ApexPages.currentPage().getParameters().get('Id') != null) {
            prodId = ApexPages.currentPage().getParameters().get('Id');
        } else {        
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Product query error'));
        }
    }
    
    public Product_Table__c getProd() {
        if (prodId != null) {
            return [SELECT Name, Image__c, Product_description__c, 
                	Unit_price__c, Units_available__c,
                    Warehouse__r.Name
                	FROM Product_Table__c WHERE Id = : prodId];
        } else {
            return null;
        }
    }
    
   	public PageReference buyPage() {
        PageReference pageRef = new PageReference(Page.Practice4BuyPage.getUrl());
        pageRef.getParameters().put('id', prodId);
		pageRef.setRedirect(true);
		return pageRef;
    } 
      
}