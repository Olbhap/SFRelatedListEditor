({
    loadRelatedLists : function(component, event) {
        //Get the related list for the given object        
        var metadataAction = component.get("c.getReleatedListsMetadata");
        
        metadataAction.setParams({
            "objectId": component.get("v.recordId")
        });
        
        metadataAction.setCallback(this, function(res) {			
            if (res.getState() === "SUCCESS") { 
                component.set("v.relatedLists", res.getReturnValue());
            } 
            else if (res.getState() === "ERROR") {
                $A.log("Errors", res.getError());
            }           
        });  
        
        $A.enqueueAction(metadataAction);   
    }
})