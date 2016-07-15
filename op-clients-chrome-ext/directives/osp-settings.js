angular.module('osp', [])
    .factory("ospService", function () {

        getUserSettings = function (callback) {

            chrome.storage.local.get('sn_privacy_settings', function (settings) {
                callback(settings);
            });
        };

        setUserSetting = function(settingName, settingValue){

            chrome.storage.local.get('sn_privacy_settings', function(settings){

                if(!(settings instanceof Object) || Object.keys(settings).length === 0){
                    settings = [];
                }
                else{
                    settings = settings.sn_privacy_settings;
                }

                var isNew = true;
                for(var i = 0; i<settings.length; i++){

                    if(settings[i].settingKey == settingName){
                        settings[i].settingValue = settingValue;
                        isNew = false;
                        break;
                    }
                }

                if(isNew == true){
                    settings.push({settingKey: settingName, settingValue: settingValue});
                }


                chrome.storage.local.set({sn_privacy_settings: settings}, function() {
                    console.log("salvat");
                });

            });

        }


        return {
            getUserSettings: getUserSettings,
            setUserSetting: setUserSetting
        }

    })

    .directive('ospSettings', function () {
        return {
            restrict: 'E',
            replace: false,
            scope: {config: "="},

            controller: ["$scope","ospService",function ($scope, ospService) {

                 ospService.getUserSettings(function(userSettings){

                     if (userSettings.sn_privacy_settings) {
                         userSettings.sn_privacy_settings.forEach(function (setting) {

                             if($scope.config[setting.settingKey]){
                                 $scope.config[setting.settingKey].userSetting = setting.settingValue;
                                 $scope.$apply();
                             }
                         });
                     }
                 });

                $scope.$on("received-setting", function (event, args) {

                    if (args.settingValue == undefined) {
                        args.settingValue = "undefined";
                    }

                    $scope.config[args.settingKey].userSetting = args.settingValue;

                    ospService.setUserSetting(args.settingKey,args.settingValue);
                    $scope.$apply();
                });
            }],

            templateUrl: '/operando/tpl/osp/osps.html'
        }
    })
    .directive('ospSetting', function () {
        return {
            restrict: 'E',
            replace: false,
            scope: {
                settingKey: "=",
                settingValue: "=",
                userSetting: "=",
                recommendedSetting: "="
            },
            require: "^ospSettings",


            controller: function ($scope) {
                //console.log($scope.settingValue.name);
            },
            templateUrl: '/operando/tpl/osp/osp.html'
        }
    })
    .directive('readSnSettings', function () {
        return {
            restrict: "E",
            replace: false,
            scope: {
                osp: "="
            },
            controller: function ($scope) {
                var tabId = null;
                $scope.readSocialNetworkPrivacySettings = function () {

                    (function () {

                        var port = null;
                        var currentTabUrl = null;

                        var tabIsNew = true;

                        var snSettings = ospSettingsConfig[$scope.osp];
                        var settings_arr = []

                        for (var key in snSettings) {

                            var currentSetting = snSettings[key]["read"];

                            currentSetting.settingKey = key;
                            settings_arr.push(currentSetting);

                            /*if(Object.keys(currentSetting.jquery_selector).length !== 0){
                             currentSetting.settingKey = key;
                             settings_arr.push(currentSetting);
                             }*/
                        }


                        var queryPage = function (setting) {

                            return new Promise(function (resolve, reject) {

                                if (currentTabUrl == setting.url) {
                                    tabIsNew = false;
                                    port.postMessage({command: "scan", setting: setting});
                                }
                                else {
                                    chrome.tabs.update(tabId, {url: setting.url}, function (tab) {
                                        currentTab = tab;
                                        tabIsNew = true;
                                    });
                                }

                                currentCallback = function () {
                                    resolve("finishedCommand");
                                }

                                currentSetting = setting;
                                currentTabUrl = setting.url;

                            });

                        }

                        var insertJavascriptFile = function (id, file, callback) {

                            chrome.tabs.executeScript(id, {
                                file: file
                            }, function () {
                                if (chrome.runtime.lastError) {
                                    console.error(chrome.runtime.lastError.message);
                                }
                                else if (callback) {
                                    callback();
                                }
                            });

                        }


                        var sequence = Promise.resolve();


                        sequence = sequence.then(function () {
                            return new Promise(function (resolve, reject) {
                                chrome.tabs.create({active: false}, function (tab) {
                                    tabId = tab.id;
                                    resolve(tabId);
                                });
                            });
                        });


                        sequence = sequence.then(function () {
                            chrome.runtime.onConnect.addListener(function (_port) {

                                port = _port;
                                if (port.name == "getSNSettings") {
                                    port.onMessage.addListener(function (msg) {
                                        if (msg.status == "waitingCommand" && tabIsNew == true) {
                                            if (currentSetting !== undefined) {
                                                port.postMessage({command: "scan", setting: currentSetting});
                                            }
                                        }
                                        else {
                                            if (msg.status == "finishedCommand") {
                                                $scope.$parent.$broadcast("received-setting", {
                                                    settingKey: msg.settingKey,
                                                    settingValue: msg.settingValue
                                                });
                                                console.log(msg.settingValue);
                                                currentCallback();
                                            }
                                        }
                                    })

                                }

                            });


                        });

                        sequence = sequence.then(function () {
                            chrome.tabs.onUpdated.addListener(function (tabId, changeInfo) {
                                if (tabId == currentTab.id && changeInfo.status == "complete" && tabIsNew == true) {
                                    insertJavascriptFile(currentTab.id, "operando/utils/jquery-2.1.4.min.js", function () {
                                        insertJavascriptFile(currentTab.id, "operando/modules/readSocialNetworkSettings.js", function () {
                                        });
                                    });
                                }
                            });
                        });


                        settings_arr.forEach(function (setting) {
                            sequence = sequence.then(function () {
                                return queryPage(setting);
                            }).then(function (result) {
                                //console.log(result);
                            }).catch(function (err) {
                                console.log(err);
                            });
                        });


                        sequence = sequence.then(function () {
                            chrome.tabs.remove(tabId);
                            port.disconnect();
                            port = null;
                            /*
                             TODO remove this
                             fix the event listener
                             */
                            window.location.reload();

                        });

                    })();
                }
            },
            templateUrl: '/operando/tpl/osp/read_settings_btn.html'

        }
    });
