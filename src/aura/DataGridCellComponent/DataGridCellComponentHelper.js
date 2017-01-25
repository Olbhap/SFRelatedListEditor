({
    doInit : function(component, event) {         
        var item = component.get("v.item");
        var column = component.get("v.column");
                
        //Set the column label
        component.set("v.label", column.label); 
        //Set the value from the item
        component.set("v.value", item[column.name]);                
        //Set the required flag for all fields
        component.set("v.required", JSON.parse(column.required));
        //Set the length for String field
        component.set("v.length", JSON.parse(column.length));
        //Set the options for Picklist field
        component.set("v.options", JSON.parse(column.options));
        //Set the digits for Integer field
        component.set("v.digits", JSON.parse(column.digits));
        //Set the precision for Integer field
        component.set("v.precision", JSON.parse(column.precision));                
    },    
    getInputCell : function(component, event){
        return component.find("inputCell");
    },   
    checkRequired : function(cellInput, component, event){
        if(component.get("v.required") && !cellInput.get("v.value")){            
            component.set("v.errors", [{
                message:"This field is required"
            }]);         
        }  
    },   
    checkEmail : function (cellInput, component, event) {
        var value = cellInput.get("v.value");
        
        if (value && !value.match("^[a-zA-Z0-9\._-]+\@[a-zA-Z0-9\._-]+\.[a-zA-z0-9]{2,4}$")) {
            component.set("v.errors", [{
                message: "Invalid email: " + value
            }]);
        }      
    },
    checkDate : function (cellInput, component, event) {
        var value = cellInput.get("v.value");
        
        if (value){
            try{
                $A.localizationService.formatDate(value, "dd/MM/yyyy");
            }
            catch (e) {
                component.set("v.errors", [{
                    message: "Invalid date: " + value
                }]);
            }
        }
    },    
    checkDigits : function (cellInput, component, event) {
        var digits = component.get("v.digits");
        var value = cellInput.get("v.value");
        
        if (value && value.toString().length > digits) {
            component.set("v.errors", [{
                message: "Input too long: >" + digits
            }]);
        }
    },
    checkPrecision : function (cellInput, component, event) {
        var precision = component.get("v.precision");
        var value = cellInput.get("v.value");
        
        if (value && value.toString().length > precision) {
            component.set("v.errors", [{
                message: "Input too long: >" + precision
            }]);
        }
    },
    beforeCheckInput : function(component, event){        
        component.set("v.hasErrors", false);
        component.set("v.errors", []); 
    },
    afterCheckInput : function(component, event){
        component.set("v.hasErrors", component.get("v.errors").length > 0);       
    },
    customCheckInput : function(cellInput, component, event){
        //Virtual function
    }
}