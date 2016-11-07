({
    doInit : function(component, event, helper) {                
        //Get the related list for the given object        
      	helper.loadRelatedLists(component, event);
    }
 })