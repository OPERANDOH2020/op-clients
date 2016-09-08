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
            getNextQuestionAndSuggestions: function(activeOptions,callback){
                messengerService.send("getNextQuestionAndSuggestions",
                    {
                        'activeOptions':activeOptions
                    },
                    callback)
            },
            completeWizard: function (currentSetting,callback) {
                messengerService.send("completeWizard",currentSetting, callback)
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


                
                var ospSettings = ospService.getOSPSettings();

                var numOptions = 0;
                $scope.idToQuestion = {};
                $scope.idToAnswer = {};
                $scope.answerToId = {}
                
                for(var network in ospSettings){
                    for(var setting in ospSettings[network]){
                        if(ospSettings[network][setting].id){
                            $scope.idToQuestion[ospSettings[network][setting].id] = setting;
                            for(var option in ospSettings[network][setting]['read']){
                                $scope.idToAnswer[ospSettings[network][setting]['read'].index] = {
                                    'answer':option,
                                    'question':setting
                                }

                                $scope.answerToId[option] = ospSettings[network][setting]['read'].index;

                                if(numOptions<ospSettings[network][setting]['read'].index+1){
                                    numOptions = ospSettings[network][setting]['read'].index+1
                                }
                            }
                        }
                    }
                }





                $scope.current_settings = {};
                $scope.current_question = {};
                $scope.currentAnswers = [];
                $scope.view = "options";

                var getNextQuestion = function () {
                    PrivacyWizardService.getNextQuestionAndSuggestions($scope.current_settings, function (current_question) {
                        $scope.current_question = current_question;

                        $scope.current_question.possible_answers = $scope.current_question.map(function(answerId){
                            return idToAnswer[answerId]['answer']
                        });
                        $scope.current_question['question'] = idToQuestion[$scope.current_question['question_id']];

                        $scope.$apply();
                    });
                };

                getNextQuestion();

                $scope.next = function () {

                    if ($scope.view == "options") {
                        
                        $scope.currentAnswers.push($scope.current_question.selected);


                        $scope.suggestedQuestions = {};

                        $scope.current_question.suggestions[$scope.possible_choices_ids.indexOf($scope.current_question.selected)].forEach(function(answerId){
                            $scope.suggestedQuestions[$scope.idToAnswer[answerId]['question']] = answerId;
                        });

                        $scope.view = "suggestions";
                        $scope.$apply();

                    }
                    else {
                        if ($scope.current_settings[$scope.current_question.question_id]) {
                            for (var sq in  $scope.suggestedQuestions) {
                                $scope.current_settings[$scope.current_question.question_id].push($scope.suggestedQuestions[sq].selected);
                            }
                        }

                        var step = angular.copy($scope.current_question);
                        step.current_settings = angular.copy($scope.current_settings);

                        if(step.currentAnswers.length===numOptions){
                            $scope.view = "completed";
                            $scope.$apply();
                        }
                        else {
                            $scope.view = "options";
                            getNextQuestion();
                        }

                    }
                };

                $scope.someSelected = function () {
                    return $scope.current_question.selected;
                }

            }],
            templateUrl: "/operando/tpl/privacy-wizard/privacy_wizard.html"
        }
    });