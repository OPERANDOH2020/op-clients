var DOMElement = function (element) {
    if (!(element instanceof HTMLElement)) {
        throw "Element is not a jQuery object";
    }
    else {
        this.element = element;
        this.isLoginField = false;
        this.isRegisterField = false;
    }
}

DOMElement.prototype = {
    isInLoginForm: function () {
        return this.isLoginField;
    },
    isInRegisterForm: function () {
        return this.isRegisterField;
    },
    setAsLoginField: function () {
        this.isLoginField = true;
    },
    setAsRegisterField: function () {
        this.isRegisterField = true;
    },
    executeJob:function(task){
        task(this.element);
    }
}


var InputsPool = function (selector, task) {
    var self = this;
    this.selector = selector;
    this.inputElements = [];
    this.task = task;
    var scanInterval = null;

    function handleVisibilityChange() {
        if (document.hidden) {
            if (scanInterval) {
                clearInterval(scanInterval);
            }
        } else {
            scanInterval = setInterval(function () {
                jQuery(selector).each(function (index, element) {
                    self.addInputElement(element);
                });
            }, 1000);
        }
    }

    document.addEventListener("visibilitychange", handleVisibilityChange, false);
    handleVisibilityChange();
}

InputsPool.prototype = {
    addInputElement: function (el) {
        var self = this;
        var htmlElementAlreadyExists = false;
        this.inputElements.forEach(function(inputElement){
            if(inputElement.element === el){
                htmlElementAlreadyExists = true;
            }
        });

        if(!htmlElementAlreadyExists){
            var newElement = new DOMElement(el);
            newElement.executeJob(self.task);
            this.inputElements.push(newElement);
        }
    },

    removeInputElement: function (el) {
        for (var i = 0; i <= this.inputElements.length; i++) {
            if(this.inputElements[i] === el){
                this.inputElements.splice(i,1);
            }
        }
    },

    setFieldTasks : function(taskFn){
    }
}



