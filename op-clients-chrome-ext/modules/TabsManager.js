
var authenticationService = require("authentication-service").authenticationService;

var BrowserTab = function (id, port){
    this.tab = tab;
    this.port = port;
};

BrowserTab.prototype = {

    onTabUpdated:function(){

    },
    onRemoved:function(){

    },
    onCreated:function(){

    },
    onHighlighted:function(){

    },
    onActivated:function(){

    }
};

var TabsManager = function(){
    init();

    this.browserTabs = [];

    chrome.tabs.onUpdated.addListener(function(tabId,changeInfo,tab){
        if (tab.url) {

            if (changeInfo.status === "complete" && tab.url.indexOf(ExtensionConfig.WEBSITE_HOST) != -1) {
                establishPlusPrivacyWebsiteCommunication(tabId);
            }
            if (authenticationService.isLoggedIn()) {
                if (changeInfo.status === "complete" && tab.url.indexOf("http") != -1) {
                    suggestSubstituteIdentities(tabId);
                }

                if (changeInfo.status === "complete") {
                    //suggestPrivacyForBenefits(tab);
                }
            }
        }
    });
};

function suggestSubstituteIdentities(tabId){
    injectScript(tabId, "operando/modules/identity/input-track.js", ["jQuery","Tooltipster","UserPrefs","DOMElementProvider"], function(){
        insertCSS(tabId,"operando/assets/css/change-identity.css");
        insertCSS(tabId,"operando/utils/tooltipster/tooltipster.bundle.min.css");
        insertCSS(tabId,"operando/utils/tooltipster/tooltipster-plus-privacy.css");
    });
}

function suggestPrivacyForBenefits(tab) {

    var pfbHandler = swarmHub.startSwarm("pfb.js", "getWebsiteDeal", tab.url, tab.id);
    pfbHandler.onResponse("success", function (swarm) {
        chrome.tabs.get(swarm.tabId, function (tab) {
            if (tab) {
                var deal = swarm.deal;
                var tabId = tab.id;
                insertJavascriptFile(tabId, "operando/utils/jquery.min.js");
                insertJavascriptFile(tabId, "operando/utils/jquery.visible.min.js");
                insertJavascriptFile(tabId, "operando/utils/webui-popover/jquery.webui-popover.js");
                chrome.tabs.insertCSS(tabId, {file: "operando/utils/webui-popover/jquery.webui-popover.css"});
                insertJavascriptFile(tabId, "operando/modules/pfb/operando_content.js", function () {
                    chrome.tabs.sendMessage(tabId, {pfbDeal: deal}, {}, function (response) {
                        if (response !== undefined) {
                            swarmHub.startSwarm("pfb.js", "acceptDeal", deal.serviceId);
                        }
                    });
                });
            }
        });
    });
}

function establishPlusPrivacyWebsiteCommunication(tabId){
    insertJavascriptFile(tabId, "operando/modules/communication/message-relay.js");
}

function init(){
    chrome.tabs.query({url:"*://"+ExtensionConfig.WEBSITE_HOST+"/*"}, function (tabs){
        tabs.forEach(function(tab){
            establishPlusPrivacyWebsiteCommunication(tab.id);
        });
    });
}

TabsManager.prototype = {
    registerTab : function(tab){
        this.browserTabs.push(tab);
    }
};

exports.TabsManager = new TabsManager();
