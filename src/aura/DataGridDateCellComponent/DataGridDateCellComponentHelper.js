({
    customCheckInput : function(cellInput, component, event){
        this.checkRequired(cellInput, component, event);   
        this.checkDate(cellInput, component, event);
    }
})