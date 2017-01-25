({
    doCustomInit : function(component, event){
        var item = component.get("v.item");
        var column = component.get("v.column");
        
        if(item[column.name]){
            component.set("v.refValue", "/one/one.app#/sObject/" + item[column.name] + "/view");
            component.set("v.refLabel", item[column.name + '__Name']);                                
        }
        else{
            component.set("v.isSearching", true);                                
        }
        
        component.set("v.refObjName", column.refObjName);
    },
    searchByName : function (component, event) {
        //Clear search result info
        component.set('v.searchResults',[]);
        component.set('v.hasResults',false);
        component.set('v.isSelecting', false);
        
        //Call the controller action
        var action = component.get("c.getLookupCandidates");
        action.setParams({
            refObjName: component.get('v.refObjName'),
            searchTerm: component.get('v.searchTerm')
        });
        
        action.setCallback(this, function(response) {       
            if (response.getState() === "SUCCESS") {
                component.set('v.hasResults',true);
                component.set('v.searchResults',response.getReturnValue());                	                             
            }
        });
        
        $A.enqueueAction(action);
    },    
    setResultsInfo : function (component, event) {        
        //Clear results 
        component.set('v.hasResults',false);
        component.set('v.isSelecting', false);
        
        //Update the component from the selected candidate
        component.set('v.searchTerm', null);    
        component.set("v.isSearching", false);
        
        component.set('v.refLabel', event.currentTarget.title);    
        component.set('v.value',event.currentTarget.id);         
        
        //Update Errors 
        component.set("v.hasErrors", false);
        component.set("v.errors", []);         
    },
    resetAfterBlur : function(component, event){
        if(!component.get('v.isSelecting')){
            //Reset search properties
            component.set('v.searchTerm',null);    
            component.set('v.hasResults',false);    
            
            //Check required flag
            if(component.get("v.required")){
                component.set("v.hasErrors", true);
                component.set("v.errors", [{
                    message:"This field is required"
                }]);         
            }  
        }  
    },
    resetBeforeSearch : function(component, event){
        //Reset lookup properties
        component.set('v.value', null); 
        component.set('v.refLabel', null);       
        component.set('v.isSearching', true); 
        
        //Check required flag
        if(component.get("v.required")){
            component.set("v.hasErrors", true);
            component.set("v.errors", [{
                message:"This field is required"
            }]);         
        } 
    }		
})