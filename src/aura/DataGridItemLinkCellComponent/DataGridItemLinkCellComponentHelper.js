({
    doCustomInit : function(component, event){
        var item = component.get("v.item");

        component.set("v.refValue", "/one/one.app#/sObject/" + item.Id + "/view");
        component.set("v.refLabel", component.getReference("v.value"));      
    }
})