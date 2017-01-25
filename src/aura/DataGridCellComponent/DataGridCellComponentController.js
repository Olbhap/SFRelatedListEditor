({
    doInit : function(component, event, helper) {              
        helper.doInit(component, event);
    },
    checkInput : function(component, event, helper) {
        var cellInput = helper.getInputCell(component, event); 
        
		helper.beforeCheckInput(component, event);
        helper.customCheckInput(cellInput, component, event);
        helper.afterCheckInput(component, event);
    },
    toggleErrTooltip : function(component, event, helper) {
        var toggleText = component.find("tooltip");
        $A.util.toggleClass(toggleText, "tooltip-toggle");
    }
})