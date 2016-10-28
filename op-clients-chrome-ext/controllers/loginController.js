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

    $scope.info = {
        message: "",
        status: ""
    };



    $scope.loginAreaState = "loggedout";

    //show login form
    $scope.show_login = function () {
        $scope.loginAreaState = "login_form";
    }

    $scope.cancel = function (formName) {
        $validationProvider.reset(formName);
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
            }
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
            $scope.user.username = user.userName;
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
        messengerService.send("login", {
            login_details: {
                username: $scope.user.email,
                password: $scope.user.password,
                remember_me: $scope.user.remember_me
            }
        }, function (response) {
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
        console.log($scope.user);
        $scope.info.status = "success";
        $scope.info.message = 'Resetting your password...';

        messengerService.send("resetPassword", $scope.user.email, function (data) {

            if (data.status === "success") {
                $scope.info.status = "success";
                $scope.info.message = 'A new password was sent to your email!';
                $scope.show_login();
                $scope.$apply();
            }
            else {
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

        var successFunction = function(){
            $scope.loginAreaState = "login_form";
            $scope.info.status = "success";
            $scope.info.message = 'Registration was successful!';
            clearInfoPanel();
            $scope.$apply();
        }

        var errorFunction = function(errorMessage){
            $scope.info.message = errorMessage;
            $scope.info.status = "error";
            $scope.$apply();
        }

        messengerService.send("registerUser",{user:$scope.user}, function(response){

            if(response.status == "success"){
                successFunction();
            }
            else if(response.status == "error"){
                errorFunction(response.message);
            }
        });

    }

    $scope.$watch('loginAreaState', function(){
        if($scope.info.status =="error"){
            $scope.info = {
                message: "",
                status: ""
            };
        }
    });

    $scope.logout = function(){
        messengerService.send("logout",function(){
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

