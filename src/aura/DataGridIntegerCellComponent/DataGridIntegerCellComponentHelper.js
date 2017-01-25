({
    customCheckInput : function(cellInput, component, event){
        this.checkRequired(cellInput, component, event);   
        this.checkDigits(cellInput, component, event);
    }
})