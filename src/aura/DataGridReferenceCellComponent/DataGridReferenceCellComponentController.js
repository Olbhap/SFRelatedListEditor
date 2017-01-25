({
    doInit : function(component, event, helper) {              
        helper.doInit(component, event); 
        helper.doCustomInit(component, event); 
    },
    handleSearchChange : function(component, event, helper) {
        if (component.get('v.searchTerm') && 
            component.get('v.searchTerm').length>2){
            helper.searchByName(component, event);
        }
    },
    handleResultSelect: function(component, event, helper) {
        helper.setResultsInfo(component,event);         
    },
    handleSearchBlur : function(component, event, helper){
        helper.resetAfterBlur(component, event);                
    },
    toggleSelecting : function(component, event, helper){
        var isSelecting = component.get('v.isSelecting');
        component.set('v.isSelecting',!isSelecting);
    },
    toggleSearching : function(component, event, helper){
        helper.resetBeforeSearch(component, event);
    }
})