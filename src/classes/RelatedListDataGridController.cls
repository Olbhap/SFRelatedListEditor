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
                columnKey = (String)mColumn.get('lookupId');
                mColumn.put('name', columnKey);
            }
            
            Schema.SObjectField sfield = relatedObjDesc.fields.getMap().get(columnKey);           
            if(sfield != null){
                DescribeFieldResult fieldDescResult = sfield.getDescribe(); 
                
                if(fieldDescResult.isAccessible()){
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
            List<String> notAccessibleFields = new List<String>();
        	Map<String, DescribeFieldResult> lookupFields = new Map<String,DescribeFieldResult>();
        	Map<String, DescribeFieldResult> picklistFields = new Map<String,DescribeFieldResult>();
        
            Id firstChildId = (Id)((Map<String, Object>) items.get(0)).get('Id');            
        	DescribeSObjectResult objectDescResult = firstChildId.getSobjectType().getDescribe();
            
            for(Schema.SObjectField sfield : objectDescResult.fields.getMap().Values()){ 
                DescribeFieldResult fieldDescResult = sfield.getDescribe();
                //Build the list of not accessible fields
                if(!fieldDescResult.isAccessible()){
                    notAccessibleFields.add(fieldDescResult.getName());
                }                
                else{
                    //Build the list of lookup fields            
                 	if(fieldDescResult.getType()==Schema.DisplayType.REFERENCE){                        
                    	lookupFields.put(fieldDescResult.getName(), fieldDescResult);
                	}
                    //Build the list of picklist fields            
                    if(fieldDescResult.getType()==Schema.DisplayType.PICKLIST){
                    	picklistFields.put(fieldDescResult.getName(), fieldDescResult);
                	}
                }
            }   

            for(Object item : items){
                Map<String, Object> mItem = (Map<String, Object>) item;
                //Clean the list based on the field accessibility
                for(String field : notAccessibleFields){
                    mItem.remove(field);
                }
                
                //Set the lookup labels based on the field type
                for(String fieldKey : lookupFields.keySet()){
                    if(mItem.containsKey(fieldKey)){
                        Id lookupId = (Id)mItem.get(fieldKey);
                        if(lookupId != null){
                            SObject lookupObj = getLookupObject(lookupId);
                            mItem.put(fieldKey + '__Name', lookupObj.get('Name'));                                                        
                        }                        
                    }
                }
                
                //Set the picklist options based on the field type
                for(String fieldKey : picklistFields.keySet()){
                    if(mItem.containsKey(fieldKey)){
                        DescribeFieldResult fieldDesc = picklistFields.get(fieldKey);
                        mItem.put(fieldKey + '__options', JSON.serialize(fieldDesc.getPicklistValues()));                        
                    }
                }
            }
            
            return items;                    
        }
                
        return null;
    } 
    
    /**
     * Return the object based on the lookup id
     * */
    private static SObject getLookupObject(Id lookupId)
    {
        Schema.SObjectType sobjectType = lookupId.getSObjectType();
		String sobjectName = sobjectType.getDescribe().getName();
        
		return Database.query('Select Id, Name From ' + 
                              sobjectName + 
                              ' Where Id = :lookupId');
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
                        String dateStr = ((String)mObj.get(field)) + ' 00:00:00';
                        sObj.put(field, Date.valueOf(dateStr));                    
                    }
                    else if(sfield.getDescribe().getType() == Schema.DisplayType.DATETIME){
                        String datetimeStr = ((String)mObj.get(field)).replace('T', ' ').replace('000Z', '');
                        sObj.put(field, Datetime.valueOf(datetimeStr));                    
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
}