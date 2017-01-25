public with sharing class RelatedListDataGridController {      
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
    * Clean the related list metadata
	* -If the field is AutoNumber or Calculated set the type to Formula. Otherwise set the type from the map
	* -If the column is not an inner field set the type to Reference
	* -If the field is not accessible remove the field from columns list  
	* */
    private static void cleanRelatedListMetadata(Map<String, Object> mRelatedListMetadata)
    {
        Object[] columns = (Object[] )mRelatedListMetadata.get('columns');                
        String relatedObjectName = (String)mRelatedListMetadata.get('sobject');
        
        Schema.SObjectType relatedObjType = Schema.getGlobalDescribe().get(relatedObjectName);
        Schema.DescribeSObjectResult relatedObjDesc = relatedObjType.getDescribe();        
        
        for(Integer i=0; i<columns.size(); i++){
            Map<String, Object> mColumn = (Map<String, Object>) columns.get(i);
            String columnKey = (String)mColumn.get('name');
            
            //If it's a Picklist field
            if(columnKey.startsWith('toLabel(')){
                columnKey = columnKey.substringBetween('toLabel(', ')');
                mColumn.put('name', columnKey);
            }
            //If it's a Reference field
            if(columnKey.endsWith('.Name')){                
                mColumn.put('refObjName', ((String)mColumn.get('field')).replace('.Name', ''));
                columnKey = (String)mColumn.get('lookupId');
                mColumn.put('name', columnKey);                
            }
            
            Schema.SObjectField sfield = relatedObjDesc.fields.getMap().get(columnKey);           
            if(sfield != null){
                DescribeFieldResult fieldDescResult = sfield.getDescribe(); 
                
                if(fieldDescResult.isAccessible()){
                    //Set requied flag
                    mColumn.put('required', JSON.serialize(!fieldDescResult.isNillable()));
                    
                    //Set precision
                    mColumn.put('precision', JSON.serialize(fieldDescResult.getPrecision()));
                    
                    //Set picklistValues
                    mColumn.put('options', JSON.serialize(fieldDescResult.getPicklistValues()));
                    
                    //Set digits
                    mColumn.put('digits', JSON.serialize(fieldDescResult.getDigits()));
                    
                    //Set length
                    mColumn.put('length', JSON.serialize(fieldDescResult.getLength()));
                    
                    //Set type for AutoNumber and Formula Fields
                    mColumn.put('type', typesMap.get(fieldDescResult.getType()));                    
                    if(fieldDescResult.isAutoNumber() || fieldDescResult.isCalculated()){
                        mColumn.put('type', 'Formula');                    
                    }                    
                }else{
                    columns.remove(i);
                }                            
            }else{
                mColumn.put('type', 'Reference');                    
            }
        }
    }
    
    /**
    * Return the list of related metadata information
    * */
    @AuraEnabled
    public static Object[] getReleatedListsMetadata(Id objectId)
    {
        String recordTypeName = RestAPIUtils.getObjectRecordTypeName(objectId);
        Object[] relatedListsMetatdata = RestAPIUtils.getRelatedListsMetadata(objectId, 
                                                                              recordTypeName);
        
        for(Object relatedListMetadata : relatedListsMetatdata){
            cleanRelatedListMetadata((Map<String, Object>)relatedListMetadata); 
        }
        
        return relatedListsMetatdata;
    }
    
    /**
    * Return the metadata of the related list
    * */
    @AuraEnabled
    public static Object getReleatedListMetadata(Id objectId, 
                                                 String relatedListLabel)
    {
        String recordTypeName = RestAPIUtils.getObjectRecordTypeName(objectId);
        Object[] relatedListsMetatdata = RestAPIUtils.getRelatedListsMetadata(objectId, 
                                                                              recordTypeName);
        
        for(Object relatedListMetadata : relatedListsMetatdata){
            Map<String, Object> mRelatedListMetadata = (Map<String, Object>)relatedListMetadata;
            if(mRelatedListMetadata.get('label') == relatedListLabel){
                cleanRelatedListMetadata(mRelatedListMetadata); 
                return mRelatedListMetadata;
            }
        }           
        
        return null;
    }        
    
    /**
    * Return the the related list items
    * */
    @AuraEnabled
    public static Object[] getReleatedListItems(Id objectId, 
                                                String relatedlistName)
    {            
        Object[] items = RestAPIUtils.getRelatedListItems(objectId, 
                                                              relatedlistName);
        if(items.size()>0){        
            Id firstChildId = (Id)((Map<String, Object>) items.get(0)).get('Id');            
        	DescribeSObjectResult objectDescResult = firstChildId.getSobjectType().getDescribe();
            
        	Map<String, DescribeFieldResult> lookupFields = new Map<String,DescribeFieldResult>();            
            for(Schema.SObjectField sfield : objectDescResult.fields.getMap().Values()){ 
                DescribeFieldResult fieldDescResult = sfield.getDescribe();                
                if(fieldDescResult.getType()==Schema.DisplayType.REFERENCE){                        
                    lookupFields.put(fieldDescResult.getName(), fieldDescResult);
                }                                
            }   
			
            //Set the lookup labels based on the field type
            for(String fieldKey : lookupFields.keySet()){
                Set<Id> lookupIds = new Set<Id>();
                Map<Id, List<Object>> lookupMap = new Map<Id, List<Object>>();                
                
                //Build the list of IDs
                for(Object item : items){
                    Map<String, Object> mItem = (Map<String, Object>) item;
                    if(mItem.containsKey(fieldKey)){
                        Id lookupId = (Id)mItem.get(fieldKey);
                        if(lookupId != null){
                            lookupIds.add(lookupId); 
                            if(!lookupMap.containsKey(lookupId)){
                                lookupMap.put(lookupId, new List<Object>());
                            }
                            lookupMap.get(lookupId).add(mItem);
                        }                        
                    }
                }
                               
                //Do SOQL query based on the ID list
                if(!lookupIds.isEmpty()){
                    SObject[] lookupObjs = getLookupObjects(lookupIds);                 
                    for(SObject lookupObj : lookupObjs){
                        for(Object item : lookupMap.get(lookupObj.Id)){
                            Map<String, Object> mItem = (Map<String, Object>) item;
                            try{                            	
                                mItem.put(fieldKey + '__Name', lookupObj.get('Name'));                                                                                        
                            }
                            catch(Exception e){
                                System.debug(e.getMessage());
                                mItem.put(fieldKey + '__Name', 'Undefined'); 
                            }
                        }
                    }
                }
            }                            
            
            return items;                    
        }
                
        return null;
    } 
    
    /**
     * Return the list of objects based on the lookup ids
     * */
    private static SObject[] getLookupObjects(Set<Id> lookupIds)
    {
        Schema.SObjectType sobjectType = (new list<Id>(lookupIds))[0].getSObjectType();
        String sobjectName = sobjectType.getDescribe().getName();
        
        return Database.query('Select Id, Name From ' + 
                              sobjectName + 
                              ' Where Id in :lookupIds');                   
    }
    
    /**
    * Save the related list items
    * */
    @AuraEnabled
    public static boolean saveRelatedListItems(String jsonData)
    {
        List<SObject> sObjectsItems = new List<SObject>();
        
        Object[] items = (Object[])JSON.deserializeUntyped(jsonData);
        
        for(Object obj : items) {
            Map<String, Object> mObj = (Map<String, Object>)obj;
            
            //Init the SObject instance
            Id objId = (Id)mObj.get('Id');
            Schema.SObjectType objType = objId.getSobjectType();
            SObject sObj = objType.newSObject(objId);
            
            //Update the fields
            for(String field : mObj.keySet()){
                Schema.SObjectField sfield = objType.getDescribe().fields.getMap().get(field);
                if(sfield != null && sfield.getDescribe().isUpdateable()){
                    if(sfield.getDescribe().getType() == Schema.DisplayType.DATE){
                        if(mObj.get(field) != null){
                            String dateStr = ((String)mObj.get(field)) + ' 00:00:00';
                            sObj.put(field, Date.valueOf(dateStr));                                                
                        }
                    }
                    else if(sfield.getDescribe().getType() == Schema.DisplayType.DATETIME){
                        if(mObj.get(field) != null){
                            String datetimeStr = ((String)mObj.get(field)).replace('T', ' ').replace('000Z', '');
                            sObj.put(field, Datetime.valueOf(datetimeStr));                    
                        }
                    }
                    else{                        
                        sObj.put(field, mObj.get(field));                    
                    }                    
                }                    
            }
            
            sObjectsItems.add(sObj);
        }
        
        update sObjectsItems;
        return true;
    } 
    
    /**
     * Search Candiate for Lookup Field
     * */
    @AuraEnabled
	public static Object[] getLookupCandidates(String refObjName, String searchTerm) {
        String soqlQuery = 'Select Id,Name From '+ refObjName+ 
            ' Where Name Like \'%' + searchTerm + '%\''+' Limit 5';
        
        return Database.query(soqlQuery);
	}
}