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

operandoCore
    .factory("watchDogService", ["ospService", "cfpLoadingBar", function (ospService, cfpLoadingBar) {




        var FACEBOOK_PRIVACY_URL = "https://www.facebook.com/settings?tab=privacy&section=composer&view";
        var LINKEDIN_PRIVACY_URL = "https://www.linkedin.com/psettings/";
        var port = null;
        var facebookTabId = null;
        var linkedinTabId = null;



        function updateProgressBar(){

        }

        function increaseFacebookPrivacy(settings, callback, jobFinished) {
            chrome.tabs.create({url: FACEBOOK_PRIVACY_URL, "selected": false}, function (tab) {
                cfpLoadingBar.start();
                facebookTabId = tab.id;
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

                    chrome.tabs.executeScript(facebookTabId, {
                        code: "window.FACEBOOK_PARAMS = " + JSON.stringify(response.template)
                    }, function () {
                        insertCSS(facebookTabId, "operando/assets/css/feedback.css");
                        injectScript(facebookTabId, "operando/modules/osp/writeFacebookSettings.js", ["FeedbackProgress", "jQuery"]);
                    });
                });
            });

            (function (settings) {
                chrome.runtime.onConnect.addListener(function (_port) {
                    if (_port.name == "applyFacebookSettings") {
                        port = _port;
                        port.onMessage.addListener(function (msg) {
                            if (msg.status == "waitingCommand") {
                                port.postMessage({command: "applySettings", settings: settings});
                            } else {
                                if (msg.status == "settings_applied") {
                                    cfpLoadingBar.complete();
                                    jobFinished();
                                    //chrome.tabs.update(facebookTabId, {url: "https://www.facebook.com/settings?tab=privacy"});
                                }
                                else {
                                    if (msg.status == "progress") {
                                        callback("facebook",msg.progress, settings.length);
                                        cfpLoadingBar.set(msg.progress);
                                    }
                                }
                            }
                        });
                    }
                });
            })(settings);
        }

        function  increaseLinkedInPrivacy(settings, callback, jobFinished) {
            chrome.tabs.create({url: LINKEDIN_PRIVACY_URL, "selected": false}, function (tab) {
                cfpLoadingBar.start();
                linkedinTabId = tab.id;
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

                    chrome.tabs.executeScript(linkedinTabId, {
                        code: "window.FACEBOOK_PARAMS = " + JSON.stringify(response.template)
                    }, function () {
                        insertCSS(linkedinTabId, "operando/assets/css/feedback.css");
                        injectScript(linkedinTabId, "operando/modules/osp/writeLinkedinSettings.js", ["FeedbackProgress", "jQuery"]);
                    });
                });
            });

            (function (settings) {
                chrome.runtime.onConnect.addListener(function (_port) {
                    if (_port.name == "applyLinkedinSettings") {
                        port = _port;
                        port.onMessage.addListener(function (msg) {
                            if (msg.status == "waitingCommand") {
                                port.postMessage({command: "applySettings", settings: settings});
                            } else {
                                if (msg.status == "settings_applied") {
                                    cfpLoadingBar.complete();
                                    jobFinished();
                                    chrome.tabs.update(facebookTabId, {url: "https://www.facebook.com/settings?tab=privacy"});
                                }
                                else {
                                    if (msg.status == "progress") {
                                        callback("linkedin",msg.progress, settings.length);
                                        cfpLoadingBar.set(msg.progress);
                                    }
                                }
                            }
                        });
                    }
                })
            })(settings);
        }


        var secureAccount = function (desiredSettings, callback, completedCallback) {

            var desiredSettings = desiredSettings.sort(function (a, b) {
                return a - b
            });


            ospService.getOSPSettings(function (settings) {

                var settingsToBeApplied = {};
                for (var i = 0; i < desiredSettings.length; i++) {
                    var found = false;
                    for (ospname in settings) {
                        if (found === false) {

                            for (setting in settings[ospname]) {

                                if (typeof settings[ospname][setting].read.availableSettings !== "object") {
                                    continue;
                                }
                                var result = Object.keys(settings[ospname][setting].read.availableSettings).filter(function (s) {
                                    return parseInt(settings[ospname][setting].read.availableSettings[s].index) == parseInt(desiredSettings[i]);
                                });

                                if (result.length > 0) {

                                    if (!settingsToBeApplied[ospname]) {
                                        settingsToBeApplied[ospname] = [];
                                    }

                                    settingsToBeApplied[ospname].push(prepareSettings(settings[ospname][setting].write, result[0]));

                                    found = true;
                                    break;
                                }
                            }
                        }
                    }
                }

                startApplyingSettings(settingsToBeApplied, callback, completedCallback);
            });

        }

        function startApplyingSettings(settings, callback, completedCallback) {

            var jobsNumber = Object.keys(settings).length;

            if(jobsNumber === 0){
                completedCallback();
            }

            var jobFinished = function(){
                jobsNumber --;
                if(jobsNumber ===0){
                    completedCallback();
                }
            }

            for (ospname in settings) {
                switch (ospname) {
                    case "facebook":
                        increaseFacebookPrivacy(settings[ospname],callback, jobFinished);
                        break;
                    case "linkedin":
                        increaseLinkedInPrivacy(settings[ospname],callback, jobFinished);
                        break;
                }
            }

        }



        function prepareSettings(settingToBeApplied, settingKey) {

            var name = settingToBeApplied.name;
            var urlToPost = settingToBeApplied.url_template;
            var page = settingToBeApplied.page;
            var data = settingToBeApplied.data ? settingToBeApplied.data : {};

            var params = settingToBeApplied.availableSettings[settingKey].params;


            for (key in params) {
                var param = params[key];

                if (typeof param.value !== 'undefined') {
                    urlToPost = urlToPost.replace("{" + param.placeholder + "}", param.value);
                }
                /**
                 * else we replace later when we are in SN page and will take the value from there
                 */
            }

            if (settingToBeApplied.availableSettings[settingKey].data) {
                var specificData = settingToBeApplied.availableSettings[settingKey].data;
                for (var attrname in specificData) {
                    data[attrname] = specificData[attrname];
                }
            }

            var setting = {
                name: name,
                type: settingToBeApplied.type,
                url: urlToPost,
                params: settingToBeApplied.availableSettings[settingKey].params,
                page: page,
                data: data
            };
            return setting;

        }

        var maximizeEnforcement = function(callback, completedCallback){

            ospService.getOSPSettings(function (settings) {

                var settingsToBeApplied = {};

                for (ospname in settings) {

                    for (setting in settings[ospname]) {

                        var s = settings[ospname][setting];

                         if(s.write.recommended && s.write.availableSettings && s.write.availableSettings[s.write.recommended]){

                             if (!settingsToBeApplied[ospname]) {
                                 settingsToBeApplied[ospname] = [];
                             }

                             settingsToBeApplied[ospname].push(prepareSettings(s.write, s.write.recommended));
                         }
                    }
                }

                startApplyingSettings(settingsToBeApplied, callback, completedCallback);

            });


        }

        return {
            secureAccount: secureAccount,
            maximizeEnforcement:maximizeEnforcement
        }

    }]);
