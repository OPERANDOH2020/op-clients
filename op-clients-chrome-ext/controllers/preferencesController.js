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

angular.module('operando').controller('PreferencesController', ["$scope", "$attrs", "cfpLoadingBar", "ospService", function ($scope, $attrs, cfpLoadingBar, ospService) {


    var settings = [];

    if ($attrs.socialNetwork) {
        $scope.schema = ospService.generateAngularForm($attrs.socialNetwork);

        $scope.form = [];
        for (var key in $scope.schema.properties) {
            $scope.form.push({
                key: key,
                type: "radios",
                titleMap: $scope.schema.properties[key].enum
            })
        }

        $scope.form.push(
            {
                type: "submit",
                title: "Save"
            }
        );

        $scope.model = {};
        $scope.submitPreferences = function () {

            ospService.getOSPSettings(function(ospWriteSettings){

                settings = [];
                for (var settingKey in $scope.model) {
                    console.log($scope.model[settingKey]);
                    if (ospWriteSettings[settingKey].write.availableSettings) {
                        console.log(ospWriteSettings[settingKey].write.availableSettings[$scope.model[settingKey]]);
                        var name = ospWriteSettings[settingKey].write.name;
                        var urlToPost = ospWriteSettings[settingKey].write.url_template;
                        var page = ospWriteSettings[settingKey].write.page;
                        var data = ospWriteSettings[settingKey].write.data ? ospWriteSettings[settingKey].write.data : {};

                        var params = ospWriteSettings[settingKey].write.availableSettings[$scope.model[settingKey]].params;


                        for (key in params) {
                            var param = params[key];

                            if(param.value){
                                urlToPost = urlToPost.replace("{" + param.placeholder + "}", param.value);
                            }
                            /**
                             * else we replace later when we are in SN page and will take the value from there
                             */

                        }

                        if (ospWriteSettings[settingKey].write.availableSettings[$scope.model[settingKey]].data) {
                            var specificData = ospWriteSettings[settingKey].write.availableSettings[$scope.model[settingKey]].data
                            for (var attrname in specificData) {
                                data[attrname] = specificData[attrname];
                            }
                        }

                        settings.push({
                            name: name,
                            type:ospWriteSettings[settingKey].write.type,
                            url: urlToPost,
                            params:ospWriteSettings[settingKey].write.availableSettings[$scope.model[settingKey]].params,
                            page: page,
                            data: data
                        });

                    }
                    else {
                        console.log(settingKey + " setting not found!");
                    }
                }

                console.log(settings);
                switch ($attrs.socialNetwork){
                    case "facebook" : increaseFacebookPrivacy(settings); break;
                    case "linkedin" : increaseLinkedInPrivacy(settings); break;
                }


            },$attrs.socialNetwork);

        }
    }

    var FACEBOOK_PRIVACY_URL = "https://www.facebook.com/settings?tab=privacy&section=composer&view";
    var LINKEDIN_PRIVACY_URL = "https://www.linkedin.com/psettings/"
    var port = null;
    var facebookTabId = null;
    var linkedinTabId = null;

    var increaseFacebookPrivacy = function () {
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
    }

    var increaseLinkedInPrivacy = function(){
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
    }


    chrome.runtime.onConnect.addListener(function (_port) {
        if (_port.name == "applyFacebookSettings") {
            port = _port;
            port.onMessage.addListener(function (msg) {
                if (msg.status == "waitingCommand") {
                    port.postMessage({command: "applySettings", settings: settings});
                } else {
                    if (msg.status == "settings_applied") {
                        cfpLoadingBar.complete();
                        //chrome.tabs.update(facebookTabId, {url: "https://www.facebook.com/settings?tab=privacy"});
                    }
                    else {
                        if (msg.status == "progress") {
                            console.log(msg.progress);
                            cfpLoadingBar.set(msg.progress);
                        }
                    }
                }
            });
        }
    });


    chrome.runtime.onConnect.addListener(function (_port) {
        if (_port.name == "applyLinkedinSettings") {
            port = _port;
            port.onMessage.addListener(function (msg) {
                if (msg.status == "waitingCommand") {
                    port.postMessage({command: "applySettings", settings: settings});
                } else {
                    if (msg.status == "settings_applied") {
                        cfpLoadingBar.complete();
                        //chrome.tabs.update(facebookTabId, {url: "https://www.facebook.com/settings?tab=privacy"});
                    }
                    else {
                        if (msg.status == "progress") {
                            console.log(msg.progress);
                            cfpLoadingBar.set(msg.progress);
                        }
                    }
                }
            });
        }
    });


}]);
