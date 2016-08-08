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

        completeWizard = function (callback) {
            messengerService.send("completeWizard", {}, function (question) {
                callback(question);
            });
        }


        return {
            getNextQuestion: getNextQuestion,
            completeWizard: completeWizard
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
                $scope.view = "options";

                var getNextQuestion = function () {
                    PrivacyWizardService.getNextQuestion($scope.current_settings, function (current_question) {
                        $scope.current_question = current_question;

                        for (var i = 0; i < $scope.current_question.possible_choices_ids.length; i++) {
                            $scope.current_question.possible_choices_ids[i] = {
                                key: $scope.current_question.possible_choices_ids[i]
                            }
                        }


                        for (var option in $scope.current_question.suggestions) {
                            for (var i = 0; i < $scope.current_question.suggestions[option].length; i++) {
                                $scope.current_question.suggestions[option][i] = {
                                    key: $scope.current_question.suggestions[option][i],
                                    selected: true
                                }
                            }
                        }

                        $scope.$apply();
                    });
                }

                getNextQuestion();

                $scope.next = function () {

                    if ($scope.view == "options") {

                        if (!$scope.current_settings[$scope.current_question.question_id]) {
                            $scope.current_settings[$scope.current_question.question_id] = [];
                        }

                        $scope.current_question.possible_choices_ids.forEach(function (item) {
                            if(item.selected){
                                $scope.current_settings[$scope.current_question.question_id].push(item.key);
                            }
                        });

                        $scope.view = "suggestions";

                    }
                    else {
                        for (var option in $scope.current_question.suggestions) {
                            if ($scope.current_settings[$scope.current_question.question_id].indexOf(option) != -1) {
                                $scope.current_question.suggestions[option].forEach(function (item) {
                                    if (item.selected) {
                                        $scope.current_settings[$scope.current_question.question_id].push(item.key);
                                    }
                                });
                            }
                        }

                        $scope.view = "options";
                        getNextQuestion();
                    }

                }

                $scope.optionIsSelected = function (key) {

                    var possible_options = $scope.current_question.possible_choices_ids;

                    for (var i = 0; i < possible_options.length; i++) {
                        var option = possible_options[i];
                        if (option.key == key && option.selected == true) {
                            return true;

                        }
                    }

                    return false;
                };

                $scope.someSelected = function () {
                    if (!$scope.current_question.possible_choices_ids) {
                        return false;
                    }

                    var arr_filter = $scope.current_question.possible_choices_ids.filter(function (value) {
                        return value.selected ? true : false;

                    });

                    return arr_filter.length > 0 ? true : false;
                }

            }],
            templateUrl: "/operando/tpl/privacy-wizard/privacy_wizard.html"
        }
    });