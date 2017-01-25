({
    customCheckInput : function(cellInput, component, event){
        this.checkRequired(cellInput, component, event);   
        this.checkEmail(cellInput, component, event);
    }
})