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

        getNextQuestion = function (currentSetting, callback) {
            messengerService.send("getNextQuestion", currentSetting, function (question) {
                callback(question);

            });
        }

        completeWizard = function (currentSetting, all_suggestions,callback) {
            messengerService.send("completeWizard", {currentSetting:currentSetting, all_suggestions:all_suggestions}, function () {
                callback();
            });
        }

        getSuggestedQuestions = function (options, callback) {
            messengerService.send("getSuggestedQuestions", options, function (questions) {
                callback(questions);
            });
        }


        return {
            getNextQuestion: getNextQuestion,
            completeWizard: completeWizard,
            getSuggestedQuestions: getSuggestedQuestions
        }
    }])
    .directive("privacyWizard", function ($rootScope) {

        return {
            restrict: 'E',
            replace: true,
            scope: {},
            controller: ["$scope", "PrivacyWizardService", function ($scope, PrivacyWizardService) {

                $scope.current_settings = {};
                $scope.current_question = {};
                $scope.all_suggestions = [];
                $scope.view = "options";

                var getNextQuestion = function () {
                    PrivacyWizardService.getNextQuestion($scope.current_settings, function (current_question) {
                        $scope.current_question = current_question;
                        $scope.$apply();
                    });
                }

                getNextQuestion();

                $scope.next = function () {

                    if ($scope.view == "options") {

                        if (!$scope.current_settings[$scope.current_question.question_id]) {
                            $scope.current_settings[$scope.current_question.question_id] = [];
                        }

                        $scope.current_settings[$scope.current_question.question_id].push($scope.current_question.selected);

                        PrivacyWizardService.getSuggestedQuestions($scope.current_question.suggestions[$scope.current_question.selected], function (questions) {
                            $scope.suggestedQuestions = questions;

                            for (var q in $scope.suggestedQuestions) {
                                var options = angular.copy($scope.suggestedQuestions[q]);
                                $scope.suggestedQuestions[q] = {};
                                $scope.suggestedQuestions[q].options = options;

                                $scope.suggestedQuestions[q].selected = null;
                                var options = $scope.suggestedQuestions[q].options;

                                $scope.suggestedQuestions[q].selected = $scope.current_question.suggestions[$scope.current_question.selected].filter(function (value) {
                                    return options.indexOf(value) > -1;
                                })[0];
                            }
                            $scope.view = "suggestions";
                            $scope.$apply();

                        });

                    }
                    else {

                        if ($scope.current_settings[$scope.current_question.question_id]) {
                            for (var sq in  $scope.suggestedQuestions) {
                                $scope.current_settings[$scope.current_question.question_id].push($scope.suggestedQuestions[sq].selected);
                            }
                        }


                        var step = angular.copy($scope.current_question);
                        step.current_settings = angular.copy($scope.current_settings);
                        $scope.all_suggestions.push(step);

                        if (Object.keys($scope.current_settings).length >= 3) {

                            PrivacyWizardService.completeWizard($scope.current_settings, $scope.all_suggestions, function(){
                                $scope.view = "completed";
                                $scope.$apply();
                            });

                        }
                        else {
                            $scope.view = "options";
                            getNextQuestion();
                        }

                    }
                }

                $scope.someSelected = function () {
                    return $scope.current_question.selected;
                }

            }],
            templateUrl: "/operando/tpl/privacy-wizard/privacy_wizard.html"
        }
    });