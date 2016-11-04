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
        ModalService.showModal({

            templateUrl: '/operando/tpl/modals/single_click_enforcement.html',
            controller: ["$scope", "close", "watchDogService", function ($scope, close, watchDogService) {
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
            }]

        }).then(function (modal) {
            modal.element.modal();
        });
    }


    $attrs.$observe('socialNetwork', function(value) {

            $scope.socialNetwork = value;
            $scope.isLastOspInList = false;
            ospService.getOSPs(function(osps){
                if(osps.indexOf($scope.socialNetwork) == osps.length-1){
                    $scope.isLastOspInList = true;
                }

                $scope.goToNextOsp = function(){
                    $state.go('preferences.sn',{sn:osps[osps.indexOf($scope.socialNetwork)+1]});
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
                        console.log($scope.model[settingKey]);
                        if (ospWriteSettings[settingKey].write.availableSettings) {
                            console.log(ospWriteSettings[settingKey].write.availableSettings[$scope.model[settingKey]]);
                            var name = ospWriteSettings[settingKey].write.name;
                            var urlToPost = ospWriteSettings[settingKey].write.url_template;
                            var page = ospWriteSettings[settingKey].write.page;
                            var data = ospWriteSettings[settingKey].write.data ? ospWriteSettings[settingKey].write.data : {};

                            console.log($scope.model[settingKey]);
                            var params = ospWriteSettings[settingKey].write.availableSettings[$scope.model[settingKey]].params;


                            for (key in params) {
                                var param = params[key];

                                if(param.value){
                                    urlToPost = urlToPost.replace("{" + param.placeholder + "}", param.value);
                                }

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

                    switch ($scope.socialNetwork){

                        case "facebook" : showModalProgress("Facebook",settings, watchDogService.applyFacebookSettings);break;
                        case "linkedin" : showModalProgress("Linkedin",settings, watchDogService.applyLinkedInSettings);break;

                    }

                },$scope.socialNetwork);

            }
    });
}]);
