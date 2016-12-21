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

angular.module('operando').controller('PreferencesController', ["$scope", "$attrs", "cfpLoadingBar", "ospService","$state","watchDogService","ModalService",
    function ($scope, $attrs, cfpLoadingBar, ospService, $state, watchDogService, ModalService) {

    var settings = [];


    function showModalProgress(socialNetwork, settings, watchDogAction){

        var searchCookieInterval = null;

        ModalService.showModal({

            templateUrl: '/operando/tpl/modals/single_click_enforcement.html',
            controller: ["$scope", "close", "watchDogService", function ($scope) {

                function checkIfIsLoggedIn(socialNetwork, callback){
                    $scope.socialNetwork = socialNetwork;
                    var url;
                    var cookieName;

                    switch (socialNetwork){
                        case "Facebook": url="https://facebook.com"; cookieName = "c_user"; break;
                        case "LinkedIn": url="https://www.linkedin.com"; cookieName = "li_at"; break;
                    }


                    searchCookieInterval = setInterval(function (){
                        chrome.cookies.get({url: url, name: cookieName}, function (cookie) {
                            if (cookie) {
                                $scope.isLoggedIn = true;
                                callback();
                                clearInterval(searchCookieInterval);
                            }
                            else{
                                $scope.isLoggedIn = false;
                                $scope.$apply();
                            }
                        });
                    },1000);
                }

                checkIfIsLoggedIn(socialNetwork, function(){
                    $scope.progresses = {};
                    watchDogAction(settings, function(ospname, current, total){
                        $scope.progresses[ospname] = {
                            ospName: ospname,
                            current: current,
                            total: total,
                            status: current < total ? "pending" : "completed"
                        }
                        $scope.$apply();
                    }, function(){
                        $scope.completedFeedback = socialNetwork + " privacy settings were updated!";
                        $scope.completed = true;
                    });
                });
            }]

        }).then(function (modal) {
            modal.element.modal({
                backdrop: 'static'
            });
            modal.closed.then(function() {
                clearInterval(searchCookieInterval);
            });
        });
    }


    $attrs.$observe('socialNetwork', function(value) {

            $scope.socialNetwork = value;
            $scope.isLastOspInList = false;
            $scope.isFirstOspInList = false;
            ospService.getOSPs(function(osps){
                if(osps.indexOf($scope.socialNetwork) === osps.length-1){
                    $scope.isLastOspInList = true;
                }
                else if(osps.indexOf($scope.socialNetwork) === 0){
                    $scope.isFirstOspInList = true;
                }

                $scope.goToNextOsp = function(){
                    $state.go('preferences.sn',{sn:osps[osps.indexOf($scope.socialNetwork)+1]});
                }
                $scope.goToPreviousOsp = function(){
                    $state.go('preferences.sn',{sn:osps[osps.indexOf($scope.socialNetwork)-1]});
                }
            });

            $scope.done = function(){
                $state.transitionTo('home');
            }


            $scope.schema = ospService.generateAngularForm($scope.socialNetwork);

            $scope.form = [];
            for (var key in $scope.schema.properties) {
                $scope.form.push({
                    key: key,
                    type: "radios",
                    titleMap: $scope.schema.properties[key].enum,
                    default: $scope.schema.properties[key].recommended
                })
                $scope.schema.properties[key].default = $scope.schema.properties[key].recommended;
            }

            $scope.model = {};
            $scope.submitPreferences = function () {

                ospService.getOSPSettings(function(ospWriteSettings){

                    settings = [];
                    for (var settingKey in $scope.model) {
                        settings.push(watchDogService.prepareSettings(ospWriteSettings[settingKey].write, $scope.model[settingKey]));
                    }

                    switch ($scope.socialNetwork){

                        case "facebook" : showModalProgress("Facebook",settings, watchDogService.applyFacebookSettings);break;
                        case "linkedin" : showModalProgress("LinkedIn",settings, watchDogService.applyLinkedInSettings);break;

                    }

                },$scope.socialNetwork);

            }
    });
}]);
