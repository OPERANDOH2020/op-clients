/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    RAFAEL MASTALERU (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

var FACEBOOK_PRIVACY_URL = "https://www.facebook.com/settings?tab=privacy&section=composer&view";
var LINKEDN_PRIVACY_URL = "https://www.linkedin.com/settings/?trk=nav_account_sub_nav_settings";


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


            //TODO move this to background

            chrome.runtime.onMessage.addListener(
                function(request, sender, sendResponse) {
                 if(sender.tab.id == tab.id){
                     if(request.sender == "facebook"){


                         chrome.tabs.update(tab.id,{url:"https://www.facebook.com/settings?tab=privacy"});
                     }
                 }
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



window.addEventListener("DOMContentLoaded", function () {

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


/**
* from chromeadblockplus/firstRun.js
**/

"use strict";
(function()
{
    // Load subscriptions for features
    var featureSubscriptions = [
        {
            feature: "malware",
            homepage: "http://malwaredomains.com/",
            title: "Malware Domains",
            url: "https://easylist-downloads.adblockplus.org/malwaredomains_full.txt"
        },
        {
            feature: "social",
            homepage: "https://www.fanboy.co.nz/",
            title: "Fanboy's Social Blocking List",
            url: "https://easylist-downloads.adblockplus.org/fanboy-social.txt"
        },
        {
            feature: "tracking",
            homepage: "https://easylist.adblockplus.org/",
            title: "EasyPrivacy",
            url: "https://easylist-downloads.adblockplus.org/easyprivacy.txt"
        }
    ];

    function onDOMLoaded()
    {
         // Set up feature buttons linked to subscriptions
        featureSubscriptions.forEach(initToggleSubscriptionButton);
        updateToggleButtons();
        ext.onMessage.addListener(function(message)
        {
            if (message.type == "subscriptions.listen")
            {
                updateToggleButtons();
            }
        });
        ext.backgroundPage.sendMessage({
            type: "subscriptions.listen",
            filter: ["added", "removed", "updated", "disabled"]
        });
    }

    function initToggleSubscriptionButton(featureSubscription)
    {
        var feature = featureSubscription.feature;

        var element = E("toggle-" + feature);
        element.addEventListener("click", function(event)
        {
         //sendingMessage is blocking the css transition
         setTimeout(function(){
             ext.backgroundPage.sendMessage({
                 type: "subscriptions.toggle",
                 url: featureSubscription.url,
                 title: featureSubscription.title,
                 homepage: featureSubscription.homepage
             });
         },300);

        }, false);
    }

    function updateToggleButtons()
    {
        ext.backgroundPage.sendMessage({
            type: "subscriptions.get",
            downloadable: true,
            ignoreDisabled: true
        }, function(subscriptions)
        {
            var known = Object.create(null);
            for (var i = 0; i < subscriptions.length; i++)
                known[subscriptions[i].url] = true;
            for (var i = 0; i < featureSubscriptions.length; i++)
            {
                var featureSubscription = featureSubscriptions[i];
                updateToggleButton(featureSubscription.feature, featureSubscription.url in known);
            }
        });
    }
    function updateToggleButton(feature, isEnabled)
    {
        console.log(feature, isEnabled);
        var button = E("toggle-" + feature);
        if (isEnabled)
            button.checked = true;
        else
            button.checked = false;
    }
    document.addEventListener("DOMContentLoaded", onDOMLoaded, false);
})();





