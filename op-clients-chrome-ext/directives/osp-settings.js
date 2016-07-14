angular.module('osp', [])
    .directive('ospSettings', function () {
        return {
            restrict: 'E',
            replace: false,
            scope: {config:"="},

            controller: function ($scope) {
                $scope.$on("received-setting", function(event, args){

                    if(args.settingValue == undefined){
                        args.settingValue = "undefined";
                    }

                    $scope.config[args.settingKey].userSetting = args.settingValue;
                    $scope.$apply();
                });
            },

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
                recommendedSetting:"="
            },
            require:"^ospSettings",


            controller: function ($scope) {
                //console.log($scope.settingValue.name);
            },
            templateUrl: '/operando/tpl/osp/osp.html'
        }
    })
    .directive('readSnSettings', function(){
        return {
            restrict: "E",
            replace:false,
            scope:{
                osp:"="
            },
            controller: function ($scope) {
                $scope.readSocialNetworkPrivacySettings = function(){


                    (function () {
                        chrome.runtime.onConnect.addListener(function (port) {


                                if (port.name == "getSNSettings") {
                                    port.onMessage.addListener(function (msg) {
                                        if (msg.status == "waitingCommand") {
                                            if(currentSetting!== undefined){
                                                port.postMessage({command: "scan", setting: currentSetting});
                                            }
                                        }
                                        else {
                                            if (msg.status == "finishedCommand") {
                                                chrome.tabs.remove(currentTab.id);
                                                console.log(currentSetting);
                                                $scope.$parent.$broadcast("received-setting",{settingKey: currentSetting.settingKey, settingValue: msg.result});
                                                currentCallback();
                                            }
                                        }
                                    })

                                }

                        });
                    })();



                    var queryPage = function(setting){

                       return new Promise(function (resolve, reject) {

                           chrome.tabs.create({url: setting.url,active:false}, function (tab) {
                               currentSetting = setting;
                               currentTab = tab;

                               insertJavascriptFile(tab.id, "operando/utils/jquery-2.1.4.min.js", function () {
                                   insertJavascriptFile(tab.id, "operando/modules/readSocialNetworkSettings.js", function () {
                                       currentCallback = function () {
                                           resolve("finishedCommand");
                                       }

                                   });
                               });
                           });
                       });
                   }

                   var insertJavascriptFile = function(id, file, callback){
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


                    var snSettings = ospSettingsConfig[$scope.osp];

                    var settings_arr = []
                    for(var key in snSettings){

                        var currentSetting = snSettings[key]["read"];

                        currentSetting.settingKey = key;
                        settings_arr.push(currentSetting);

                        /*if(Object.keys(currentSetting.jquery_selector).length !== 0){
                            currentSetting.settingKey = key;
                            settings_arr.push(currentSetting);
                        }*/
                    }

                    var sequence = Promise.resolve();
                    settings_arr.forEach(function (setting) {
                        sequence = sequence.then(function () {
                            return queryPage(setting);
                        }).then(function (result) {
                            //console.log(result);
                        }).catch(function (err) {
                            console.log(err)
                        });
                    });



                }
            },
            templateUrl: '/operando/tpl/osp/read_settings_btn.html'

        }
    });
