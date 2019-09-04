@IsTest
public class Practice4ControllerTest {
	 @IsTest
    public static void test() {
        Contact cont = new Contact(
        	FirstName = 'fname',
            LastName = 'lname',
            Email = 'e@mail.com'
        );
        insert cont;
        Warehouse__c wH = new Warehouse__c(
        	Name = 'wh1',
            Period_start__c = Date.today(),
            Period_end__c = date.today()
        );
        insert wh;
        Product_Table__c prod = new Product_Table__c(
        	Name = 'prod1',
        	Image__c = 'url1',
            Product_description__c = 'descr1',
            Unit_price__c = 1,
            Units_available__c = 2,
            Warehouse__c = wh.Id
            
        );
     	insert prod;   
        Practice4DetailPageController detPg = new Practice4DetailPageController();
        System.assertEquals(null, detPg.getProd());
        detPg.prodId = prod.Id;
        System.assertEquals(prod.Id, detPg.getProd().Id);
        System.assertEquals(prod.Id, detPg.buyPage().getParameters().get('id'));
        detPg.prodId = null;
        System.assertEquals(null, detPg.buyPage().getParameters().get('id'));
        Practice4MainPageController mainPg = new Practice4MainPageController();
        System.assertEquals(prod.Id, mainPg.getProducts()[0].Id);
        mainPg.prodId = prod.Id;
        System.assertEquals(prod.Id, mainPg.buyPage().getParameters().get('id'));
        System.assertEquals(prod.Id, mainPg.detailsPage().getParameters().get('id'));
        mainPg.prodId = null;
        System.assertEquals(null, mainPg.buyPage().getParameters().get('id'));
        System.assertEquals(null, mainPg.detailsPage().getParameters().get('id'));
        Practice4BuyPageController buyPg = new Practice4BuyPageController();
        System.assertEquals(0, buyPg.quant);
        System.assertEquals(0, buyPg.amount);
        buyPg.prodId = prod.Id;
        buyPg.prod = prod;
        System.assertEquals(prod.Id, buyPg.getProd().Id);
        buyPg.checkQuant();
        System.assert(!buyPg.showButton);
        buyPg.email = 'e@mail.com';
        buyPg.getCont();
        System.assertEquals(cont.Id, buyPg.contId);
        System.assertEquals(prod.Id, buyPg.detailsPage().getParameters().get('id'));
        buyPg.checkQuant();
        System.assert(!buyPg.showButton);
        buyPg.quant = 1;
        buyPg.checkQuant();
        System.assert(buyPg.showButton);
        buyPg.contId = null;
        buyPg.email = 'eeee@mail.tv';
        buyPg.lastName = 'name1';
        buyPg.makeOrder();
        Contact cont2 = [SELECT LastName FROM Contact WHERE Email = 'eeee@mail.tv'];
        System.assertEquals(cont2.LastName, 'name1');
        Order_table__c order = [SELECT Product_Table__c, Contact__c, Units__c FROM Order_table__c];
        System.assertEquals(prod.Id, order.Product_Table__c);
        System.assertEquals(cont2.Id, order.Contact__c);
        System.assertEquals(1, order.Units__c);
        System.assertEquals(1, prod.Units_available__c);
    }
}