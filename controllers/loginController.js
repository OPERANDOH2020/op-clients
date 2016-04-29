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


angular.module("op-popup").controller("loginCtrl", ["$scope", "authenticationService", function($scope, authenticationService){

    $scope.user = {};
    $scope.isAuthenticated = false;
    $scope.authError = null;

    $scope.connection={
        status:"",
        message:""
    }

    $scope.loginAreaState = "loggedout";

    //show login form
    $scope.show_login = function () {
        $scope.loginAreaState = "login_form";
    }

    $scope.cancel = function () {
        $scope.loginAreaState = "loggedout";
    }

    securityErrorFunction = function (err, data) {
        $scope.authError = 'Invalid user or password...';
        $scope.$apply();
    }

    errorFunction = function (err) {
        $scope.connection.status = "error";
        $scope.connection.message = 'Connection lost...';
        $scope.$apply();
    }

    successFunction = function () {
        $scope.loginAreaState = "loggedin";
        $scope.authError=null;
        $scope.$apply();
    }

    reconnectFunction = function(){
        $scope.connection.status = "success";
        $scope.connection.message = 'Connected...';
        $scope.$apply();

        setTimeout(function(){
            //reset to default
            //TODO this in UI
            //add fade effect
            $scope.connection={
                status:"",
                message:""
            }
            $scope.$apply();
        },2000);
    }


    $scope.login = function() {

        authenticationService.authenticateUser($scope.user.email, $scope.user.password, securityErrorFunction, errorFunction, successFunction);

    }

    $scope.show_register = function(){
        $scope.loginAreaState = "register_form";
    }

    $scope.register = function(){
        var userData = $scope.user;

        errorFunction = function(){
            console.log("Register error");
        }
        successFunction = function(){
            console.log("Register success");
        }

        authenticationService.registerUser($scope.user, errorFunction, successFunction);
    }

    $scope.logout = function(){
        authenticationService.logoutCurrentUser(function(){
            $scope.loginAreaState = "loggedout";
            $scope.$apply()
        });
    }

    $scope.manage_accounts = function(){
        window.open(chrome.runtime.getURL("operando/operando.html#identity_management_tab"),"operando");
    }

    authenticationService.restoreUserSession(successFunction,
        function () {
            $scope.loginAreaState = "loggedout";
        },
        errorFunction,reconnectFunction);


    authenticationService.getCurrentUser(function(user){
        $scope.user.username = user.userName;
        $scope.isAuthenticated = true;
        $scope.$apply();
    });


}]);

