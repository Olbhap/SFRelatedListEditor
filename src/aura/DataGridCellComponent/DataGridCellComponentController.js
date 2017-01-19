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
    }   
})