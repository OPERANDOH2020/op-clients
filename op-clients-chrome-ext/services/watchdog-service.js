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
        var facebookPort = null;
        var linkedInPort = null;
        var facebookTabId = null;
        var linkedinTabId = null;

        function increaseFacebookPrivacy(settings, callback, jobFinished) {
            chrome.tabs.create({url: FACEBOOK_PRIVACY_URL, "selected": false}, function (tab) {
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

            var portListener = function (port, jobFinished, callback, settings) {
                if (port.name == "applyFacebookSettings") {
                    port.onMessage.addListener(function (msg) {
                        if (msg.status == "waitingCommand") {
                            port.postMessage({command: "applySettings", settings: settings});
                            //cfpLoadingBar.start();

                        } else {
                            if (msg.status == "settings_applied") {
                                //cfpLoadingBar.complete();
                                jobFinished();
                                chrome.tabs.remove(facebookTabId);
                                port.disconnect();
                                port = null;
                                //chrome.tabs.update(facebookTabId, {url: "https://www.facebook.com/settings?tab=privacy"});
                            }
                            else {
                                if (msg.status == "progress") {
                                    console.log(msg.progress);
                                    callback("facebook", msg.progress, settings.length);
                                    //cfpLoadingBar.set(msg.progress / settings.length);
                                }
                            }
                        }
                    });
                }
            }


            this.fb_jobFinished = jobFinished;
            this.fb_callback = callback;
            this.fb_settings = settings;

            var self = this;

            var getCurrentState = function () {
                return (function (_port) {
                    facebookPort = _port;
                    var jobFinished = self.fb_jobFinished;
                    var callback = self.fb_callback;
                    var settings = self.fb_settings;
                    portListener(facebookPort, jobFinished, callback, settings);

                });
            }

            if (facebookPort === null) {
                chrome.runtime.onConnect.addListener(getCurrentState());

            }
        }

        function  increaseLinkedInPrivacy(settings, callback, jobFinished) {
            chrome.tabs.create({url: LINKEDIN_PRIVACY_URL, "selected": false}, function (tab) {
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


            var portListener =  function(port, jobFinished, callback, settings){
                if (port.name == "applyLinkedinSettings") {
                    port.onMessage.addListener(function (msg) {
                        if (msg.status == "waitingCommand") {
                            port.postMessage({command: "applySettings", settings: settings});
                            //cfpLoadingBar.start();
                        } else {
                            if (msg.status == "settings_applied") {
                                //cfpLoadingBar.complete();
                                jobFinished();
                                chrome.tabs.remove(linkedinTabId);
                            }
                            else {
                                if (msg.status == "progress") {
                                    console.log(msg.progress);
                                    callback("linkedin",msg.progress, settings.length);
                                    //cfpLoadingBar.set(msg.progress/settings.length);
                                }
                            }
                        }
                    });
                }
            };

            this.linkedin_jobFinished = jobFinished;
            this.linkedin_callback = callback;
            this.linkedin_settings = settings;

            var self = this;
            var getCurrentState = function () {
                return (function (_port) {
                    linkedInPort = _port;
                    var jobFinished = self.linkedin_jobFinished;
                    var callback = self.linkedin_callback;
                    var settings = self.linkedin_settings;
                    portListener(linkedInPort, jobFinished, callback, settings);

                });
            }

            if (linkedInPort === null) {
                chrome.runtime.onConnect.addListener(getCurrentState());

            }
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

        var maximizeEnforcement = function(availableOSPs, callback, completedCallback){

            ospService.getOSPSettings(function (settings) {

                var settingsToBeApplied = {};

                for (ospname in settings) {
                    if (availableOSPs.indexOf(ospname)>-1) {

                        for (setting in settings[ospname]) {

                            var s = settings[ospname][setting];

                            if (s.write.recommended && s.write.availableSettings && s.write.availableSettings[s.write.recommended]) {

                                if (!settingsToBeApplied[ospname]) {
                                    settingsToBeApplied[ospname] = [];
                                }

                                settingsToBeApplied[ospname].push(prepareSettings(s.write, s.write.recommended));
                            }

                        }
                    }
                }

                startApplyingSettings(settingsToBeApplied, callback, completedCallback);

            });
        }

        return {
            prepareSettings:prepareSettings,
            secureAccount: secureAccount,
            maximizeEnforcement:maximizeEnforcement,
            applySettings:startApplyingSettings,
            applyFacebookSettings:increaseFacebookPrivacy,
            applyLinkedInSettings:increaseLinkedInPrivacy,

        }

    }]);
