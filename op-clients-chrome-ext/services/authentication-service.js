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

operandoCore.factory("authenticationService", ["swarmService", "$cookies", function (swarmService, $cookies) {
        var loggedIn = false;
        var authenticatedUser = {};
        var loggedInObservable = swarmHub.createObservable();
        var notLoggedInObservable = swarmHub.createObservable();

        return {
            loggedIn: loggedIn,
            authenticateUser: function (username, password, securityFn, successFn) {
                var self = this;

                swarmService.initConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, username, password, "chromeBrowserExtension", "userLogin", securityFn );

                swarmHub.on('login.js', "success", function (swarm) {
                    loggedIn = swarm.authenticated;
                    $cookies.put("sessionId", swarm.meta.sessionId);
                    $cookies.put("userId", swarm.userId);
                    getCurrentUser(function(user){
                        self.setUser(swarm.userId);
                    })

                    successFn();
                    swarmHub.off("login.js","success");
                });
            },

            registerUser: function(user,  errorFunction, successFunction){

                swarmService.initConnection(ExtensionConfig.OPERANDO_SERVER_HOST, ExtensionConfig.OPERANDO_SERVER_PORT, user, "chromeBrowserExtension", "registeNewUser", errorFunction, errorFunction);

                swarmHub.on('register.js', "success", function (swarm) {
                    successFunction();
                });
            },

            restoreUserSession: function (successCallback, failCallback, errorCallback, reconnectCallback) {
                var username =  $cookies.get("userId");
                var sessionId = $cookies.get("sessionId");
                var self = this;

                if(!username || !sessionId){
                    failCallback();
                }

                swarmService.restoreConnection(ExtensionConfig.OPERANDO_SERVER_HOST,ExtensionConfig.OPERANDO_SERVER_PORT, username, sessionId, failCallback, errorCallback, reconnectCallback);

                swarmHub.on('login.js', "restoreSucceed", function (swarm) {
                    loggedIn = true;
                    self.setUser(swarm.userId);
                    successCallback();
                    swarmHub.off("login.js","restoreSucceed");

                });
            },

            setUser:function(userId){
                swarmHub.startSwarm('UserInfo.js', 'info',userId);
                swarmHub.on('UserInfo.js', 'result', function (response) {
                    authenticatedUser = response.result;
                    loggedInObservable.notify();
                    swarmHub.off("UserInfo.js","result");
                });
            },

            getCurrentUser: function(callback){
                loggedInObservable.observe(function(){
                    callback(authenticatedUser);
                });
            },

            disconnectUser : function(callback){
                notLoggedInObservable.observe(function(){
                    callback();
                });
            },

            getStatus: function () {
                return loggedIn;
            },

            checkStatus: function (loggedInFn, notLoggedInFn) {
                this.restoreUserSession(loggedInFn, notLoggedInFn);
            },

            logoutCurrentUser:function(callback){
                swarmHub.startSwarm("login.js","logout");
                swarmHub.on("login.js", "logoutSucceed", function(swarm){
                    authenticatedUser = {};
                    loggedIn = false;
                    notLoggedInObservable.notify();
                    $cookies.remove("userId");
                    $cookies.remove("sessionId");
                    swarmHub.off("login.js","logoutSucceed");
                    swarmService.removeConnection();
                    callback();

                });
            }
        }
    }]);
