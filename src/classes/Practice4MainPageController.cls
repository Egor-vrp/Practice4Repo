public class Practice4MainPageController {
    public List<Product_Table__c> products;
    public String prodId {get; set;}
    
    public Practice4MainPageController() {
        if (ApexPages.currentPage().getParameters().get('info') != null) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,
               ApexPages.currentPage().getParameters().get('info')));
        }
    }
    
    public List<Product_Table__c> getProducts() {
        return [SELECT Name, Image__c, Product_description__c, 
                Unit_price__c, Units_available__c     
                FROM Product_Table__c LIMIT 100];
    }
    
    public PageReference detailsPage() {
        PageReference pageRef = new PageReference(Page.Practice4DetailPage.getUrl());
        pageRef.getParameters().put('id', prodId);
		pageRef.setRedirect(true);
		return pageRef;
    }
    
    public PageReference buyPage() {
        PageReference pageRef = new PageReference(Page.Practice4BuyPage.getUrl());
        pageRef.getParameters().put('id', prodId);
		pageRef.setRedirect(true);
		return pageRef;
    }
}