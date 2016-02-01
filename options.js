var FACEBOOK_PRIVACY_URL = "https://www.facebook.com/settings?tab=privacy&section=composer&view";
var LINKEDN_PRIVACY_URL = "https://www.linkedin.com/settings/?trk=nav_account_sub_nav_settings";


window.addEventListener("DOMContentLoaded", function () {

    var increaseFacebookPrivacy = function () {
        chrome.tabs.create({url: FACEBOOK_PRIVACY_URL, "selected": true}, function (tab) {

            chrome.runtime.sendMessage({
                message: "waitForAPost",
                template: {
                    "__req": null,
                    "__dyn": null,
                    "__a": null
                }
            }, function (response) {

                chrome.tabs.executeScript(tab.id, {
                    code: "window.FACEBOOK_PARAMS = " + JSON.stringify(response.template)
                }, function () {
                    injectScript(tab.id, "operando/utils/jquery-2.1.4.min.js", function () {
                        insertCSS(tab.id, "operando/assets/css/feedback.css");
                        injectScript(tab.id, "operando/apps/facebook.js");
                    });
                });


            });

        });
    }

    var increaseLinkedInPrivacy = function () {
        chrome.tabs.create({url: LINKEDN_PRIVACY_URL, "selected": true}, function (tab) {
            injectScript(tab.id, "operando/utils/jquery-2.1.4.min.js", function () {
                insertCSS(tab.id,"operando/assets/css/feedback.css");
                injectScript(tab.id, "operando/apps/linkedin.js");

            });

        })
    }

    $("#set_linkedin_privacy").click(increaseLinkedInPrivacy);
    $("#set_facebook_privacy").click(increaseFacebookPrivacy);
}, false);

function injectScript(id, file, callback) {
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





