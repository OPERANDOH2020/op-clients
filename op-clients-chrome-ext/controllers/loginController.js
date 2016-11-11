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


angular.module("op-popup").controller("loginCtrl", ['$scope', 'messengerService','$validation', function($scope, messengerService, $validationProvider){

    var defaultUser = {remember_me:true};

    $scope.user = angular.copy(defaultUser);
    $scope.isAuthenticated = false;
    $scope.requestIsProcessed = false;

    $scope.info = {
        message: "",
        status: ""
    };

    $scope.loginAreaState = "loggedout";

    //show login form
    $scope.show_login = function () {
        $scope.loginAreaState = "login_form";
    }

    $scope.cancel = function () {
        $scope.loginAreaState = "loggedout";

    }

    clearInfoPanel = function(){
        setTimeout(function(){
            //reset to default
            //TODO this in UI
            //add fade effect
            $scope.info={
                status:"",

                message:""
            };
            delete $scope.requestStatus;
            $scope.$apply();
        },2000);
    }

    securityErrorFunction = function () {
        $scope.info.message = 'Invalid email or password...';
        $scope.info.status = "error";
        $scope.$apply();
    }

    errorFunction = function () {
        $scope.info.message = 'Connection lost...';
        $scope.info.status = "error";
        $scope.$apply();
    }

    successFunction = function () {
        messengerService.send("getCurrentUser",{}, function(user){
            $scope.loginAreaState = "loggedin";
            $scope.user.email = user.email;
            $scope.isAuthenticated = true;
            $scope.$apply();
        });
    }

    reconnectFunction = function(){
        $scope.info.status = "success";
        $scope.info.message = 'Connected...';
        $scope.$apply();
        clearInfoPanel();
    }

    $scope.login = function () {
        $scope.requestIsProcessed = true;
        messengerService.send("login", {
            login_details: {
                email: $scope.user.email,
                password: $scope.user.password,
                remember_me: $scope.user.remember_me
            }
        }, function (response) {
            $scope.requestIsProcessed = false;
            if (response.success) {
                chrome.runtime.openOptionsPage();

                setTimeout(function(){
                    window.close();
                },50);
                //successFunction();
            }
            else if (response.error)
                securityErrorFunction();
        });
    }

    $scope.reset_password = function () {
        $scope.requestIsProcessed = true;
        $scope.requestStatus = "pending";
        $scope.info.status = "success";
        $scope.info.message = 'Resetting your password...';

        messengerService.send("resetPassword", $scope.user.email, function (data) {

            $scope.requestIsProcessed = false;
            if (data.status === "success") {
                $scope.info.status = "success";
                $scope.info.message = 'Check your email!!';
                $scope.requestStatus = "completed";
                $scope.show_login();
                $scope.$apply();
            }
            else {
                delete $scope.requestStatus;
                $scope.info.status = "error";
                $scope.info.message = "An error occurred. Try again later!";
                $scope.$apply();
            }
        });
    }

    $scope.show_forgot_password = function(){
        $scope.loginAreaState = "forgot_password";
    }

    $scope.show_register = function(){
        $scope.loginAreaState = "register_form";
        $scope.user = angular.copy(defaultUser);
    }

    $scope.register = function(){

        $scope.info.status = "success";
        $scope.info.message = 'Processing...';

        $scope.requestIsProcessed = true;

        var successFunction = function(){
            $scope.loginAreaState = "login_form";
            $scope.info.status = "success";
            $scope.info.message = 'Registration was successful!';
            $scope.requestStatus = "completed";
            $scope.$apply();
            clearInfoPanel();

        }

        var errorFunction = function(errorMessage){
            $scope.info.message = errorMessage;
            $scope.info.status = "error";
            $scope.$apply();
        }

        messengerService.send("registerUser",{user:$scope.user}, function(response){

            $scope.requestIsProcessed = false;
            if(response.status == "success"){
                successFunction();
            }
            else if(response.status == "error"){
                errorFunction(response.message);
            }
        });

    }

    $scope.$watch('loginAreaState', function(){
        if($scope.info.status == "error"){
            $scope.info = {
                message: "",
                status: ""
            };
        }
    });

    $scope.logout = function(){
        $scope.requestIsProcessed = true;
        messengerService.send("logout",function(){
            $scope.requestIsProcessed = false;
            $scope.loginAreaState = "loggedout";
            $scope.isAuthenticated = false;
            $scope.user = angular.copy(defaultUser);
            $scope.$apply();
        });
    }

    messengerService.send("restoreUserSession",{}, function(status){
        if(status.success){
            successFunction();
        }
        else if(status.fail){
            $scope.loginAreaState = "loggedout";
        }
        else if(status.error){
            errorFunction();
        }
        else if(status.reconnect){
            reconnectFunction();
        }
    });


    messengerService.on("onReconnect",reconnectFunction);
    messengerService.on("onConnectionError",errorFunction);
    messengerService.on("onConnect",reconnectFunction);


}]);

