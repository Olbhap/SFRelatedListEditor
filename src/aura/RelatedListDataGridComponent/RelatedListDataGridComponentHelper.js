({
	applyShadowEffect : function(component, event) {
        //Apply the shadow effect on the grid
        var gridContainer = component.find("gridContainer");
        $A.util.toggleClass(gridContainer, "shadow-effect");
	},
    toogleEditButton : function(component, event){
        //Show/hide the edit button
        var editButton = component.find("editButton");
        $A.util.toggleClass(editButton, "hidden");
    },   
    toogleGridActions : function(component, event){
        //Show/hide the action bar on the bottom
        var gridActions = component.find("gridActions");
        $A.util.toggleClass(gridActions, "hidden");
    },
    refreshUIElements : function(component, event){
        //Apply the shadow on the grid
        this.applyShadowEffect(component, event);
        
        //Toogle the edit button
        this.toogleEditButton(component, event);
        
        //Toogle the grid actions
        this.toogleGridActions(component, event);
    },
    loadItems : function(component){
        //Load items from Salesforce
        var dataAction = component.get("c.getReleatedListItems");
        dataAction.setParams({
            "objectId": component.get("v.recordId"),
            "relatedlistName": component.get("v.relatedListName")
        });	
        
        dataAction.setCallback(this, function(res) {                        
            if (res.getState() === "SUCCESS") {                 
                var gridContainer = component.find("gridContainer");
        		$A.util.toggleClass(gridContainer, "hidden");        
                component.set("v.items", res.getReturnValue()); 
            }
            else if (res.getState() === "ERROR") {
                $A.log("Errors", res.getError());
            }
        });   
        
        $A.enqueueAction(dataAction);    
    },
    refreshItems : function(component, items, displayMode){
        //Set the display mode
        component.set("v.displayMode", displayMode); 
        
        //Refresh the items
        component.set("v.items", []);                
        component.set("v.items", items);                
    },
    updateItems : function(component){
        var cellComponents = component.find("cell");
        var items = component.get("v.items");
        
        //Update the items from cells
        for(var c=0; c < cellComponents.length; c++){
            var cellCmp = cellComponents[c];
            var column = cellCmp.get("v.column");
            var item = items[cellCmp.get("v.itemRank")];
            item[column.name] = cellCmp.get("v.value");           
        }                
        
        return items;
    },
    saveItems : function(component, items, saveCallback){
        //Save items on Salesforce
        var saveItemsAction = component.get("c.saveRelatedListItems");
        
        saveItemsAction.setParams({
            "jsonData": JSON.stringify(component.get("v.items"))
        });	
        
        saveItemsAction.setCallback(this, function(res) {            
            saveCallback(res.getState(), res.getError());
        });   
        
        $A.enqueueAction(saveItemsAction);
    }
})