@isTest
public class RelatedListDataGridControllerTest {
 	static testMethod void testGetReleatedListsMetadata()
    {
		Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new RestAPIMockHttpResponseGenerator());        
                
        Object[] relatedListsMatadata = RelatedListDataGridController.getReleatedListsMetadata('0010Y000003iFovQAE');
		System.assertEquals(7, relatedListsMatadata.size());        
        
        Test.stopTest();        
    }
    
    
    static testMethod void getReleatedListMetadata()
    {
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new RestAPIMockHttpResponseGenerator());        
                
        Object relatedListsMatadata = RelatedListDataGridController.getReleatedListMetadata('0010Y000003iFovQAE',
                                                                                            'Contacts');
		System.assertEquals(true, relatedListsMatadata != null);        
        
        Test.stopTest();         
    }
    
    static testMethod void getReleatedListItems()
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RestAPIMockHttpResponseGenerator());        
        
        Object[] contacts = RelatedListDataGridController.getReleatedListItems('0010Y000003iFovQAE', 
                                                                               'Contacts');        
		System.assertEquals(1, contacts.size());                
        
        Test.stopTest();
    } 
    
   
    static testMethod void saveRelatedListItems()
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RestAPIMockHttpResponseGenerator());        
        
        Object[] contacts = RelatedListDataGridController.getReleatedListItems('0010Y000003iFovQAE', 
                                                                               'Contacts');        
        
		Boolean result = RelatedListDataGridController.saveRelatedListItems(System.JSON.serialize(contacts));
        System.assertEquals(true, result);
        Test.stopTest();        
    }
}