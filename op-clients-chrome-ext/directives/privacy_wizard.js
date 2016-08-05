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
    .factory("PrivacyWizardService",["messengerService", function (messengerService) {

        getNextQuestion = function (callback) {
            messengerService.send("getNextQuestion", {}, function (question) {
                alert("da");
                callback(question);

            });
        }

        completeWizard = function(callback){
            messengerService.send("getNextQuestion", {}, function (question) {
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
            controller:["$scope", "PrivacyWizardService",function ($scope, PrivacyWizardService) {
                PrivacyWizardService.getNextQuestion(function(current_setting){
                    $scope.current_question = current_setting;
                    console.log($scope.current_question);
                    $scope.$apply();
                });
            }],
            templateUrl:"/operando/tpl/privacy-wizard/privacy_wizard.html"
        }
    });