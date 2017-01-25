({
    customCheckInput : function(cellInput, component, event){
        this.checkRequired(cellInput, component, event);   
        this.checkPrecision(cellInput, component, event);
    }
})