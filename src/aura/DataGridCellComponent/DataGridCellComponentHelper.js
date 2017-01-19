({
    doInit : function(component, event) {         
        var item = component.get("v.item");
        var column = component.get("v.column");
        
        if(component.get("v.columnRank")==0){
            column.type = 'ItemLink';           
        }
        
        //Set the column type
        component.set("v.type", column.type); 
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
        
        //Set the refValue/refLabel for Reference Field
        if(column.type == "Reference"){            
            component.set("v.refValue", "/one/one.app#/sObject/" + item[column.name] + "/view");
            component.set("v.refLabel", item[column.name + '__Name']);                                          
        }
        
        //Set the refValue/refLabel for ItemLink Field
        if(column.type == "ItemLink"){            
            component.set("v.refValue", "/one/one.app#/sObject/" + item.Id + "/view");
            component.set("v.refLabel", component.getReference("v.value"));                                          
        }
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
    checkType : function (cellInput, component, event) {
        var column = component.get("v.column");
        var value = cellInput.get("v.value");
        
        //Check Email
        if (column.type == "Email") {
            if (value && !value.match("^[a-zA-Z0-9\._-]+\@[a-zA-Z0-9\._-]+\.[a-zA-z0-9]{2,4}$")) {
                component.set("v.errors", [{
                    message: "Invalid email: " + value
                }]);
            }
        }
        //Check Date
        if (column.type == "Date") {
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
        }
    },    
    checkDigits : function (cellInput, component, event) {
        var column = component.get("v.column");
        var digits = component.get("v.digits");
        var value = cellInput.get("v.value");
        
        //Check Integer field
        if (column.type == "Integer") {
            if (value && value.toString().length > digits) {
                component.set("v.errors", [{
                    message: "Input too long: >" + digits
                }]);
            }
        }        
    },
    checkPrecision : function (cellInput, component, event) {
        var column = component.get("v.column");
        var precision = component.get("v.precision");
        var value = cellInput.get("v.value");
        
        //Check Double/Currency/Percent field
        if (column.type == "Double" ||
            column.type == "Currency" ||
            column.type == "Percent") {
            if (value && value.toString().length > precision) {
                component.set("v.errors", [{
                    message: "Input too long: >" + precision
                }]);
            }
        }
    }  
})