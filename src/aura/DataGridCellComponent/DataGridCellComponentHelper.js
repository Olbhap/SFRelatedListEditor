({
    doInit : function(component, event) {
        //A helper function to set the aura component
        //in the current cell or raise error
        function setCellComponent(cellComponent, status, errorMessage){            
            if (status === "SUCCESS") {
                var cellContainer = component.find("cellContainer");
                cellContainer.set("v.body", [cellComponent]);
            }
            if (status === "ERROR") {
                console.log("Error: " + errorMessage);
            }
        }
        
        var item = component.get("v.item");
        var column = component.get("v.column");
        var displayMode = component.get("v.displayMode");
        
        //Set the column label
        component.set("v.label", column.label); 
        //Set the value from the item
        component.set("v.value", item[column.name]); 
        
        //This object contains the configuration
        //of diffrent inputs depending on  the type
        //of the field (String, Date, Url...)
        var inputConfig = {
            "String" : {
                inputType : "ui:inputText",
                inputParams : {
                    "aura:id" : "inputTextCell",
                    "value" : component.getReference("v.value")
                }
            },
            "TextArea" : {
                inputType : "ui:inputText",
                inputParams : {
                    "aura:id" : "textAreaCell",
                    "value" : component.getReference("v.value")
                }
            },
            "Boolean" :{
                inputType : "ui:inputCheckbox",
                inputParams : {
                    "aura:id" : "inputCheckboxCell",
                    "value" : component.getReference("v.value")
                }
            },
            "Currency":{
                inputType : "ui:inputCurrency",
                inputParams : {
                    "aura:id": "inputCurrencyCell",
                    "value" : component.getReference("v.value")
                }
            },
            "Date":{
                inputType : "ui:inputDate",
                inputParams : {
                    "aura:id": "inputDateCell",
                    "value" : component.getReference("v.value"),
                    "format" : "dd/MM/yyyy",
                    "displayDatePicker" : true
                }
            },
            "Datetime":{
                inputType : "ui:inputDateTime",
                inputParams : {
                    "aura:id": "ui:inputDateTimeCell",
                    "value" : component.getReference("v.value"),
                    "format" : "dd/MM/yyyy hh:mm",
                    "displayDatePicker" : true
                } 
            },
            "Double":{
                inputType : "ui:inputNumber",
                inputParams : {
                    "aura:id" : "inputNumberCell",                    
                    "value" : component.getReference("v.value")                    
                }  
            },
            "Email":{
                inputType : "ui:inputEmail",
                inputParams : {
                    "aura:id": "inputEmailCell",
                    "value" : component.getReference("v.value")
                }
            },
            "Integer":{
                inputType : "ui:inputNumber",
                inputParams : {
                    "aura:id": "inputIntegerCell",
                    "value" : component.getReference("v.value")                    
                }
            },
            "Percent":{
                inputType : "ui:inputNumber",
                inputParams : {
                    "aura:id" : "inputNumberCell",
                    "value" : component.getReference("v.value")                    
                }
            },
            "PickList":{
                inputType : "ui:inputText",
                inputParams : {
                    "aura:id": "pickListCell",
                    "value" : component.getReference("v.value")
                } 
            },
            "Phone":{
                inputType : "ui:inputPhone",
                inputParams : {
                    "aura:id": "inputPhoneCell",
                    "value" : component.getReference("v.value")
                }
            },
            "Url":{
                inputType : "ui:inputURL",
                inputParams : {
                    "aura:id": "urlCell",
                    "value" : component.getReference("v.value")
                } 
            },
            "Reference":{
                inputType : "ui:outputText",
                inputParams : {
                    "aura:id": "referenceCell",
                    "value": component.getReference("v.value")
                } 
            },
            "Formula":{
                inputType : "ui:outputRichText",
                inputParams : {
                    "aura:id": "formulaCell",
                    "value": component.getReference("v.value")
                } 
            }
        };                
        var outputConfig = {
            "String" : {
                inputType : "ui:outputText",
                inputParams : {
                    "aura:id" : "outputTextCell",
                    "value" : component.getReference("v.value")
                }
            },
            "TextArea" : {
                inputType : "ui:outputText",
                inputParams : {
                    "aura:id" : "textAreaCell",
                    "value" : component.getReference("v.value")
                }
            },
            "Boolean" :{
                inputType : "ui:outputCheckbox",
                inputParams : {
                    "aura:id" : "outputCheckboxCell",
                    "value" : component.getReference("v.value")
                }
            },
            "Currency":{
                inputType : "ui:outputCurrency",
                inputParams : {
                    "aura:id": "outputCurrencyCell",
                    "value" : component.getReference("v.value")
                }
            },
            "Date":{
                inputType : "ui:outputDate",
                inputParams : {
                    "aura:id": "outputDateCell",
                    "value" : component.getReference("v.value"),
                    "format" : "dd/MM/yyyy",
                    "displayDatePicker" : true
                }
            },
            "Datetime":{
                inputType : "ui:outputDateTime",
                inputParams : {
                    "aura:id": "ui:outputDateTimeCell",
                    "value" : component.getReference("v.value"),
                    "format" : "dd/MM/yyyy hh:mm",
                    "displayDatePicker" : true
                } 
            },
            "Double":{
                inputType : "ui:outputNumber",
                inputParams : {
                    "aura:id" : "outputNumberCell",                    
                    "value" : component.getReference("v.value")                    
                }  
            },
            "Email":{
                inputType : "ui:outputEmail",
                inputParams : {
                    "aura:id": "outputEmailCell",
                    "value" : component.getReference("v.value")
                }
            },
            "Integer":{
                inputType : "ui:outputNumber",
                inputParams : {
                    "aura:id": "outputIntegerCell",
                    "value" : component.getReference("v.value")                    
                }
            },
            "Percent":{
                inputType : "ui:outputNumber",
                inputParams : {
                    "aura:id" : "outputNumberCell",
                    "value" : component.getReference("v.value")                    
                }
            },
            "PickList":{
                inputType : "ui:outputText",
                inputParams : {
                    "aura:id": "pickListCell",
                    "value" : component.getReference("v.value")
                } 
            },
            "Phone":{
                inputType : "ui:outputPhone",
                inputParams : {
                    "aura:id": "outputPhoneCell",
                    "value" : component.getReference("v.value")
                }
            },
            "Url":{
                inputType : "ui:outputURL",
                inputParams : {
                    "aura:id": "urlCell",
                    "value" : component.getReference("v.value"),
                    "label" : component.getReference("v.value")
                } 
            },
            "Reference":{
                inputType : "ui:outputText",
                inputParams : {
                    "aura:id": "referenceCell",
                    "value": component.getReference("v.value")
                } 
            },
            "Formula":{
                inputType : "ui:outputRichText",
                inputParams : {
                    "aura:id": "formulaCell",
                    "value": component.getReference("v.value")
                } 
            }
        };
        if(displayMode=="read"){
            if(component.get("v.columnRank")==0){
                $A.createComponent(
                    "ui:outputURL",
                    {
                        "aura:id": "outputUrlCell",
                        "label": component.getReference("v.value"),
                        "value": "/one/one.app#/sObject/" + item.Id + "/view"
                    },
                    setCellComponent
                ); 
            }
            else{
                $A.createComponent(
                	outputConfig[column.type].inputType,
                	outputConfig[column.type].inputParams,
                	setCellComponent
            	);                                     
            }
        }else{
            $A.createComponent(
                inputConfig[column.type].inputType,
                inputConfig[column.type].inputParams,
                setCellComponent
            );    
        }                  
    }
})