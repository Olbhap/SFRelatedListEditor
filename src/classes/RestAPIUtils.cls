public with sharing class RestAPIUtils {
    static public String SF_HOST = System.Url.getSalesforceBaseURL().toExternalForm();
    static public String QUERY_API_URL = SF_HOST + '/services/data/v38.0/tooling/query/?q=';
    static public String SOBJECT_API_URL = SF_HOST + '/services/data/v38.0/sobjects/';   
        
    public static Map<Schema.DisplayType, String> typesMap = new Map<Schema.DisplayType, String>();
    
    static {
        typesMap.put(Schema.DisplayType.TextArea, 'TextArea');
        typesMap.put(Schema.DisplayType.STRING, 'String');
        typesMap.put(Schema.DisplayType.BOOLEAN, 'Boolean');
        typesMap.put(Schema.DisplayType.COMBOBOX, 'Combobox');
        typesMap.put(Schema.DisplayType.CURRENCY, 'Currency');
        typesMap.put(Schema.DisplayType.DATE, 'Date');
        typesMap.put(Schema.DisplayType.DATETIME, 'Datetime');
        typesMap.put(Schema.DisplayType.DOUBLE, 'Double');
        typesMap.put(Schema.DisplayType.ADDRESS, 'Adress');
        typesMap.put(Schema.DisplayType.EMAIL, 'Email');
        typesMap.put(Schema.DisplayType.INTEGER, 'Integer');
        typesMap.put(Schema.DisplayType.PERCENT, 'Percent');
        typesMap.put(Schema.DisplayType.MULTIPICKLIST, 'Multi PickList');
        typesMap.put(Schema.DisplayType.PICKLIST, 'PickList');
        typesMap.put(Schema.DisplayType.PHONE, 'Phone');
        typesMap.put(Schema.DisplayType.REFERENCE, 'Reference');
        typesMap.put(Schema.DisplayType.URL, 'Url');       
    }
    
    /**
     * Helper function to call the SF Rest API
     * */
    private Static String callRestAPI(String endPoint, 
                                      String sessionId, 
                                      String method, 
                                      String body)
    {            
        HttpRequest req = new HttpRequest();
        
        req.setMethod(method);
        req.setEndpoint(endPoint);
        req.setHeader('Content-type', 'application/json');       
        req.setHeader('Authorization', 'OAuth ' + sessionId);
        Http http = new Http();
        
        HTTPResponse res = http.send(req);       
        return res.getBody();
    }
    
    /**
     * Helper function to get a session Id 
     * For Rest API calls
     * */
    public static String getSessionId()
    {
        if (Test.IsRunningTest())
        {
            return UserInfo.getSessionId();
        }else{
            PageReference newPage = Page.GetSessionIdPage;
            String content = newPage.getContent().toString();
            return content.substringBetween('<SessionId>', '</SessionId>');
        }
    }
    
    /**
     * Helper function to call the SF Query API
     * */
    public Static String callQueryAPI(String query, 
                                       String sessionId)
    {    
        return callRestAPI(QUERY_API_URL + query, 
                           sessionId,
                           'GET', null);        
    }
    
    public Static String callQueryAPI(String query)
    {    
        return callQueryAPI(query, 
                            getSessionId());        
    }
    
    /**
     * Helper function to call the SF Sobject API
     * */
    public Static String callSObjectAPI(String query)
    {  
        return callRestAPI(SOBJECT_API_URL + query, 
                           getSessionId(),
                           'GET', null);        
    }
    
    /**
     * Helper function to call the SF Url API
     * */
    public Static String callUrlAPI(String url){        
        return callRestAPI(SF_HOST + url, 
                           getSessionId(),
                           'GET', null); 
    }
    
    /**
     * Return the related lists metadata 
     * For a given object Id and a record type name
     * */
    public static Object[] getRelatedListsMetadata(Id objectId, 
                                                   String reccordType)
    {   
        String objectName = objectId.getSobjectType().getDescribe().getName();
        String jsonDescribe = callSObjectAPI(objectName + '/describe');             
        Map<String, Object> objMetadata = (Map<String, Object>)JSON.deserializeUntyped(jsonDescribe);
        
        for(Object recordInfo : (Object[])objMetadata.get('recordTypeInfos')){            
            Map<String, Object> recordInfoMap = (Map<String, Object>)recordInfo;
            
            if(reccordType == null || reccordType == recordInfoMap.get('name')){ 
                Map<String, Object> urlMap = (Map<String, Object>)recordInfoMap.get('urls');
                if(urlMap.containsKey('layout')){
                    String jsonLayout = callUrlAPI((String)urlMap.get('layout'));
                    Map<String, Object> layoutMetadata = (Map<String, Object>)JSON.deserializeUntyped(jsonLayout);
                    Object[] relatedLists = (Object[])layoutMetadata.get('relatedLists');                    
                    return relatedLists;
                }
            }                        
        }
       
        return null;
    }
    
      
    /**
     * Return the related list items
     * For a given object Id and a related list name
     * */
    public static Object[] getRelatedListItems(Id objectId, 
                                               String relatedlistName)
    {                
        String objectName = objectId.getSobjectType().getDescribe().getName();
        
        String jsonRelatedItems = callSObjectAPI(objectName + '/' +                                                 
                                                 objectId + '/' +
                                                 relatedlistName);
        try{            
            Map<String, Object> queryResult = (Map<String, Object>)JSON.deserializeUntyped(jsonRelatedItems);         
        	return (Object[])queryResult.get('records');
        }
        catch(Exception e){
            System.debug('ERROR:' + e);
            return new List<Object>();
        }
    } 
    
    public static Map<String, Object> getObject(Id objectId)
    {
        String objectName = objectId.getSobjectType().getDescribe().getName();        
        String jsonData = callSObjectAPI(objectName + '/' +                                                 
                                         objectId );
        
        return (Map<String, Object>)JSON.deserializeUntyped(jsonData);                 
    }
    
    public static String getObjectRecordTypeName(Id objectId)
    {
        Map<String, Object> mObject = getObject(objectId);
        if (mObject.containsKey('RecordTypeId')){
            Map<Id,Schema.RecordTypeInfo> recordTypeInfo = 
                objectId.getSobjectType().getDescribe().getRecordTypeInfosById();
            return recordTypeInfo.get((Id)mObject.get('RecordTypeId')).getName();            
        }
        
        return 'Master';
    }
}