var bus = require("bus-service").bus;
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
        chrome.tabs.executeScript(data.tabId, {
        }, function () {
            insertCSS(data.tabId, "operando/assets/css/feedback.css");
            injectScript(data.tabId, "operando/modules/osp/writeLinkedinSettings.js", ["FeedbackProgress", "jQuery"]);
        });
    }
}
bus.registerService(scriptInjectorService);
