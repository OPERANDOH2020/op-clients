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

angular.module('privacyWizard', [])
    .factory("PrivacyWizardService", ["messengerService", function (messengerService) {
        return {
            getNextQuestionAndSuggestions: function (activeOptions, callback) {
                messengerService.send("getNextQuestionAndSuggestions",
                    {
                        activeOptions: activeOptions
                    },
                    callback)
            },
            completeWizard: function (currentSettings, callback) {
                messengerService.send("completeWizard",{currentSettings:currentSettings}, callback);
            }
        }
        }
    ])

    .directive("privacyWizard", function ($rootScope) {

        return {
            restrict: 'E',
            replace: true,
            scope: {},
            controller: ["$scope", "PrivacyWizardService","ospService", function ($scope, PrivacyWizardService,ospService) {

                
                ospService.getOSPSettings(function(ospSettings){
                    $scope.numOptions = 0;
                    $scope.idToQuestion = {};
                    $scope.idToAnswer = {};
                    $scope.answersForQuestion = {}
                    for(var network in ospSettings){
                        for(var setting in ospSettings[network]){
                            if(ospSettings[network][setting].id){
                                $scope.numOptions++;
                                var settingObject = ospSettings[network][setting]
                                $scope.idToQuestion[ospSettings[network][setting].id] = settingObject.read.name;
                                $scope.answersForQuestion[settingObject.read.name] = []
                                for(var option in settingObject['read']['availableSettings']){
                                    $scope.idToAnswer[settingObject['read']['availableSettings'][option].index] = {
                                        /*'answer':option,*/
                                        'question':settingObject.read.name,
                                        'index':settingObject['read']['availableSettings'][option].index,
                                        'option': settingObject['read']['availableSettings'][option]
                                    }

                                    $scope.answersForQuestion[settingObject.read.name].push(settingObject['read']['availableSettings'][option])

                                }
                            }
                        }
                    }

                    $scope.current_settings = [];
                    $scope.current_question = {};
                    $scope.started = false;
                    $scope.view = "options";

                    var getNextQuestion = function () {
                        PrivacyWizardService.getNextQuestionAndSuggestions($scope.current_settings, function (response) {
                            console.log(response.data);
                            var current_question = response.data;
                            $scope.current_question = current_question;
                            if($scope.current_question.question_id>0){
                                $scope.view = "options";
                            }
                            else{
                                    $scope.view = "completed";
                                    $scope.$apply()
                            }
                            $scope.$apply();
                        });
                    };

                    getNextQuestion();

                    $scope.next = function () {

                        if ($scope.view == "options") {

                            $scope.current_settings.push($scope.current_question.selected);

                            $scope.suggestedQuestions = {};
                            $scope.current_question.suggestions[$scope.current_question.possible_choices_ids.indexOf($scope.current_question.selected)].forEach(function(answerId){

                                if($scope.idToAnswer[answerId]){
                                    $scope.suggestedQuestions[$scope.idToAnswer[answerId]['question']] = $scope.idToAnswer[answerId];
                                }

                            });

                            if($scope.current_settings.length === $scope.numOptions){
                                PrivacyWizardService.completeWizard($scope.current_settings, function(){
                                    $scope.view = "completed";
                                    $scope.$apply()
                                });
                            } else{
                                $scope.view = "suggestions";
                            }

                        }
                        else {

                            for (var sq in  $scope.suggestedQuestions) {
                                $scope.current_settings.push($scope.suggestedQuestions[sq].option.index);
                            }


                            if($scope.current_settings.length === $scope.numOptions){
                                console.log($scope.current_settings);
                                PrivacyWizardService.completeWizard($scope.current_settings, function(){
                                    $scope.view = "completed";
                                    $scope.$apply()
                                });
                            }
                            else {
                                getNextQuestion();
                            }
                        }
                    };

                    $scope.someSelected = function () {
                        return $scope.current_question.selected;
                    }
                });

            }],
            templateUrl: "/operando/tpl/privacy-wizard/privacy_wizard.html"
        }
    });