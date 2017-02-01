@isTest
public class RestAPIUtilsTest {          
    static testMethod void testGetRelatedListsMetadata(){
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new RestAPIMockHttpResponseGenerator());        
        
        String recordTypeName = RestAPIUtils.getObjectRecordTypeName('0010Y000003iFovQAE');
        Object[] relatedListsMatadata = RestAPIUtils.getRelatedListsMetadata('0010Y000003iFovQAE', recordTypeName);
		System.assertEquals(7, relatedListsMatadata.size());        
        
        Test.stopTest();
    }

    static testMethod void testGetRelatedListItems(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RestAPIMockHttpResponseGenerator());        
        
        Object[] contacts = RestAPIUtils.getRelatedListItems('0010Y000003iFovQAE', 'Contacts');        
		System.assertEquals(1, contacts.size());                
        
        Test.stopTest();
    } 
    
    static testMethod void testCallQuery(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RestAPIMockHttpResponseGenerator());        
        
        String result = RestAPIUtils.callQueryAPI('Test');
        System.assertEquals(true, result != null);
             
        Test.stopTest();
    }
}