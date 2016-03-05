var FACEBOOK_PRIVACY_URL = "https://www.facebook.com/settings?tab=privacy&section=composer&view";
var LINKEDN_PRIVACY_URL = "https://www.linkedin.com/settings/?trk=nav_account_sub_nav_settings";


window.addEventListener("DOMContentLoaded", function () {

    var increaseFacebookPrivacy = function () {
        chrome.tabs.create({url: FACEBOOK_PRIVACY_URL, "selected": false}, function (tab) {

            /*var tabId = tab.id;
            chrome.tabs.onActivated.addListener(function(activeInfo){
                if(activeInfo.tabId == tabId){
                    setTimeout(function(){
                        chrome.tabs.remove([activeInfo.tabId], function(){});
                    },10);
                }
            })*/

            chrome.runtime.sendMessage({
                message: "waitForAPost",
                template: {
                    "__req": null,
                    "__dyn": null,
                    "__a": null,
                    "fb_dtsg": null,
                    "__user": null,
                    "ttstamp": null,
                    "__rev": null
                }
            }, function (response) {
                console.log(response);

                chrome.tabs.executeScript(tab.id, {
                    code: "window.FACEBOOK_PARAMS = " + JSON.stringify(response.template)
                }, function () {
                        insertCSS(tab.id, "operando/assets/css/feedback.css");
                        injectScript(tab.id, "operando/apps/facebook.js", ["FeedbackProgress","jQuery"]);
                    });
                });
        });
    }

    var increaseLinkedInPrivacy = function () {

        chrome.tabs.create({url: LINKEDN_PRIVACY_URL, "selected": true}, function (tab) {
                insertJavascriptFile(tab.id, "operando/DependencyManager.js", function () {
                    insertCSS(tab.id, "operando/assets/css/feedback.css");
                    injectScript(tab.id, "operando/apps/linkedin.js", ["FeedbackProgress","jQuery"]);
                });
            });
    }

    $("#set_linkedin_privacy").click(increaseLinkedInPrivacy);
    $("#set_facebook_privacy").click(increaseFacebookPrivacy);
}, false);


function injectScript(id, file, dependencies, callback) {
    if (dependencies.length > 0) {
        var currentDep = dependencies.pop();
        DependencyManager.resolveDependency(currentDep, function (depFile) {
            insertJavascriptFile(id, depFile, function () {
                injectScript(id, file, dependencies, callback);
            });
        });
    }
    else {
        insertJavascriptFile(id, file, callback);
    }
}

function insertJavascriptFile(id, file, callback){
        chrome.tabs.executeScript(id, {
        file: file
    }, function () {
        if (chrome.runtime.lastError) {
            console.error(chrome.runtime.lastError.message);
        }
        else {
            if (callback) {
                callback();
            }
        }
    });
}

function insertCSS(id, file){
    chrome.tabs.insertCSS(id, {
        file: file
    });
}





