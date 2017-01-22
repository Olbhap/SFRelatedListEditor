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
    
    
    static testMethod void testGetReleatedListMetadata()
    {
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new RestAPIMockHttpResponseGenerator());        
                
        Object relatedListsMatadata = RelatedListDataGridController.getReleatedListMetadata('0010Y000003iFovQAE',
                                                                                            'Contacts');
		System.assertEquals(true, relatedListsMatadata != null);        
        
        Test.stopTest();         
    }
    
    static testMethod void testGetReleatedListItems()
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RestAPIMockHttpResponseGenerator());        
        
        Object[] contacts = RelatedListDataGridController.getReleatedListItems('0010Y000003iFovQAE', 
                                                                               'Contacts');        
		System.assertEquals(1, contacts.size());                
        
        Test.stopTest();
    } 
    
   
    static testMethod void testSaveRelatedListItems()
    {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RestAPIMockHttpResponseGenerator());        
        
        Object[] contacts = RelatedListDataGridController.getReleatedListItems('0010Y000003iFovQAE', 
                                                                               'Contacts');                
		Account account = new Account();
        account.Name='Test Account' ;
        insert account;

        Contact contact = new Contact();
        contact.Accountid= account.id;
        contact.FirstName='Test';
        contact.LastName='Test';        
        insert contact;

        Map<String, Object> mContact = (Map<String, Object>)contacts.get(0);        
        mContact.put('AccountId', contact.AccountId);
        mContact.put('Id', contact.Id);        
        mContact.remove('OwnerId');
        
		Boolean result = RelatedListDataGridController.saveRelatedListItems(System.JSON.serialize(contacts));
        System.assertEquals(true, result);
        
        Object[] candidates = RelatedListDataGridController.getLookupCandidates('Account', 'Test');
        System.assertEquals(true, candidates.size() > 0);
        
        Test.stopTest();        
    }
}