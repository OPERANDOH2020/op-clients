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

var swarmService = require("swarm-service").swarmService;
var loggedIn = false;
var authenticatedUser = {};
var loggedInObservable = swarmHub.createObservable();
var notLoggedInObservable = swarmHub.createObservable();

var authenticationService = exports.authenticationService = {

    isLoggedIn: function(){
        return loggedIn;
    },
    getUser : function(){
      return authenticatedUser;
    },
    authenticateUser: function (login_details, securityFn, successFn) {
        var self = this;

        swarmService.initConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, login_details.username, login_details.password, "chromeBrowserExtension", "userLogin", securityFn);
        console.log("Keep session ",login_details.remember_me);
        swarmHub.on('login.js', "success", function (swarm) {
            loggedIn = swarm.authenticated;

            var daysUntilCookieExpire = 1;
            if(login_details.remember_me === true){
                daysUntilCookieExpire = 365;
            }
            Cookies.set("sessionId", swarm.meta.sessionId,  { expires: daysUntilCookieExpire });
            Cookies.set("userId", swarm.userId,{ expires: daysUntilCookieExpire });
            self.setUser(swarm.userId,successFn);
            swarmHub.off("login.js", "success");
        });
    },

    registerUser: function (user, errorFunction, successFunction) {

        var self  = this;
        swarmService.initConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, "guest", "guest", "chromeBrowserExtension", "userLogin", errorFunction, errorFunction);

        /**
         * TODO
         * Remove this, add guest login from the first step
         *
         */
        setTimeout(function(){
            var registerHandler = swarmHub.startSwarm("register.js", "registerNewUser", user);
            registerHandler.onResponse("success", function(swarm){
                successFunction("success");
                self.logoutCurrentUser();
            });

            registerHandler.onResponse("error", function(swarm){
                errorFunction(swarm.error);
                self.logoutCurrentUser();
            });
        },300);
    },

    resetPassword:  function(email, successCallback, failCallback){
        var self  = this;
        swarmService.initConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, "guest", "guest", "chromeBrowserExtension", "userLogin", failCallback, failCallback);

        setTimeout(function(){
            var resetPassHandler = swarmHub.startSwarm("emails.js", "resetPassword", email);
            resetPassHandler.onResponse("emailDeliverySuccessful", function(swarm){
                successCallback("success");
                self.logoutCurrentUser();
            });

            resetPassHandler.onResponse("emailDeliveryUnsuccessful", function(swarm){
                failCallback(swarm.error);
                self.logoutCurrentUser();
            });

            resetPassHandler.onResponse("resetPasswordFailed", function(swarm){
                failCallback(swarm.error);
                self.logoutCurrentUser();
            });
        },300);
    },

    restoreUserSession: function (successCallback, failCallback, errorCallback, reconnectCallback) {
        var username = Cookies.get("userId");
        var sessionId = Cookies.get("sessionId");
        var self = this;

        if (!username || !sessionId) {
            failCallback();
        }

        swarmService.restoreConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, username, sessionId, failCallback, errorCallback, reconnectCallback);
        swarmHub.on('login.js', "restoreSucceed", function (swarm) {
            loggedIn = true;
            self.setUser(swarm.userId,successCallback);
            swarmHub.off("login.js", "restoreSucceed");
        });
    },

    setUser: function (userId, callback) {
        var setUserHandler = swarmHub.startSwarm('UserInfo.js', 'info');


        swarmHub.on("UserInfo.js","result", function(swarm){
            authenticatedUser = swarm.result;
            loggedInObservable.notify();
            if(callback){
                callback();
            }
        });

        /*setUserHandler.onResponse("result", function(response){

            authenticatedUser = response.result;
            loggedInObservable.notify();
            if(callback){
                callback();
            }
        });*/
    },

    getCurrentUser: function (callback) {
        loggedInObservable.observe(function () {
            callback(authenticatedUser);
        }, !loggedIn);
    },

    disconnectUser: function (callback) {
        notLoggedInObservable.observe(function () {
            callback();
        }, true);
    },

    logoutCurrentUser: function (callback) {
        swarmHub.startSwarm("login.js", "logout");
        swarmHub.on("login.js", "logoutSucceed", function (swarm) {
            authenticatedUser = {};
            loggedIn = false;
            notLoggedInObservable.notify();
            notLoggedInObservable = swarmHub.createObservable();
            loggedInObservable = swarmHub.createObservable();
            Cookies.remove("userId");
            Cookies.remove("sessionId");
            swarmHub.off("login.js", "logoutSucceed");
            swarmService.removeConnection();
            if(callback){
                callback();
            }
        });
    }
}
