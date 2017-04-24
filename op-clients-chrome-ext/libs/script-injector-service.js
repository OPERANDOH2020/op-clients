var bus = require("bus-service").bus;
var portObserversPool = require("observers-pool").portObserversPool;
var facebookCallback = null;
var linkedinCallback = null;
var scriptInjectorService = exports.scriptInjectorService = {

    insertFacebookIncreasePrivacyScript: function (data) {
        chrome.tabs.executeScript(data.tabId, {
            code: data.code
        }, function () {
            insertCSS(data.tabId, "operando/assets/css/feedback.css");
            injectScript(data.tabId, "operando/modules/osp/writeFacebookSettings.js", ["FeedbackProgress", "jQuery"]);
        });
    },

    insertLinkedinIncreasePrivacyScript:function(data){
        injectScript(data.tabId, "operando/modules/osp/writeLinkedinSettings.js", ["FeedbackProgress", "jQuery"], function(){
            insertCSS(data.tabId, "operando/assets/css/feedback.css");
        });
    },

    facebookMessage : function (callback){
        facebookCallback = callback;
    },

    linkedinMessage:function(callback){
        linkedinCallback = callback;
    },

    waitingFacebookCommand:function(instructions){
        facebookCallback (instructions);
    },

    waitingLinkedinCommand:function(instructions){
        linkedinCallback (instructions);
    }

};
bus.registerService(scriptInjectorService);
