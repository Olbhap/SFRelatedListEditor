({
    doInit : function(component, event, helper) {  
        //If the component is initialized 
        //From the related lists component
        //We have just to load items
        if(component.get("v.columns")){
            helper.loadItems(component);                      
        }
        //Otherwise we have to load 
        //the metadata as well
        else{
            var metadataAction = component.get("c.getReleatedListMetadata");
            
            metadataAction.setParams({
                "objectId": component.get("v.recordId"),
                "relatedListLabel": component.get("v.relatedListLabel")
            });
            
            metadataAction.setCallback(this, function(res) {            
                if (res.getState() === "SUCCESS") { 
                    component.set("v.relatedListName", res.getReturnValue().name);
                    component.set("v.columns", res.getReturnValue().columns);
                    
                    helper.loadItems(component);                      
                } 
                else if (res.getState() === "ERROR") {
                    $A.log("Errors", res.getError());
                }           
            });  
            
            $A.enqueueAction(metadataAction);               
        }
    },    
    startEdit : function(component, event, helper) {    
        //Refresh the items
        helper.refreshItems(component, component.get("v.items"), "write");               
        
        //Refresh the UI elements(Edit button and actions)
        helper.refreshUIElements(component, event);
    },
    cancelEdit : function(component, event, helper) {         
        helper.refreshItems(component, component.get("v.items"), "read");                       
        helper.refreshUIElements(component, event);        
    },
    saveEdit : function(component, event, helper) {                       
        //Update the items
        var items = helper.updateItems(component);

		//OnSave items callback
        function saveCallback(status, error){
            if(status=="SUCCESS"){
                //Refresh the items
                helper.refreshItems(component, items, "read");      
            
                //Refresh the UI elements
                helper.refreshUIElements(component, event);                    
            }
            if(status=="ERROR"){
            	$A.log("Errors", error);                    
            }
        }        
        
        //Save items in the backend
        helper.saveItems(component, items, saveCallback);
    }
})