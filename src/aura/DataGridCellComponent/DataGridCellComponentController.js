({
    doInit : function(component, event, helper) {              
        helper.doInit(component, event);
    },
    checkInput : function(component, event, helper) {
        var cellInput = helper.getInputCell(component, event); 
        component.set("v.hasErrors", false);
        component.set("v.errors", []);
        
        helper.checkRequired(cellInput, component, event);   
        helper.checkType(cellInput, component, event);          
        helper.checkPrecision(cellInput, component, event);        
        helper.checkDigits(cellInput, component, event);    
        
        component.set("v.hasErrors", component.get("v.errors").length > 0);
    },
    toggleErrTooltip : function(component, event, helper) {
        var toggleText = component.find("tooltip");
        $A.util.toggleClass(toggleText, "tooltip-toggle");
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