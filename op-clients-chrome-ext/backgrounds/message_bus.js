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


var authenticationService = require("authentication-service").authenticationService;
var swarmService = require("swarm-service").swarmService;
var identityService = require("identity-service").identityService;
var pfbService = require("pfb-service").pfbService;
var socialNetworkService = require("social-network-privacy-settings").socialNetworkService;
var privacyWizardService = require("privacy-wizard").privacyWizardService;
var ospService = require("osp-service").ospService;
var userService = require("user-service").userService;

chrome.runtime.onConnect.addListener(function (_port) {

    (function(clientPort){

        if (clientPort.name == "OPERANDO_MESSAGER") {

            /**
             * Listen for swarm connection events
             **/

            swarmService.onReconnect(function () {
                if (clientPort != null) {
                    clientPort.postMessage({type: "BACKGROUND_DEMAND", action: "onReconnect", message: {}});
                }
            });

            swarmService.onConnectionError(function () {
                if (clientPort != null) {
                    clientPort.postMessage({type: "BACKGROUND_DEMAND", action: "onConnectionError", message: {}});
                }
            });

            swarmService.onConnect(function () {
                if (clientPort != null) {
                    clientPort.postMessage({type: "BACKGROUND_DEMAND", action: "onConnect", message: {}});
                }
            });


            /**
             * Listen for commands
             **/
            clientPort.onMessage.addListener(function (request) {

                if (request.action == "login" && request.message) {
                    login(request.message.login_details, function () {
                        clientPort.postMessage({
                            type: "SOLVED_REQUEST",
                            action: request.action,
                            message: {error: "securityError"}
                        });
                    }, function () {
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: {success: "success"}});
                    });
                }

                if (request.action == "logout") {
                    logout(function () {
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: {success: "success"}});
                    });
                }

                if (request.action == "notifyWhenLogout") {
                    authenticationService.disconnectUser(function(){
                        if(clientPort){
                            clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: {success: "success"}});
                        }
                    });
                }

                if (request.action == "getCurrentUser") {
                    getCurrentUser(function (user) {
                        if(clientPort){
                            clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: user});
                        }
                    })
                }

                if (request.action == "restoreUserSession") {
                    restoreUserSession(function (status) {
                        if(clientPort) {
                            clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: status});
                        }
                    })
                }

                if(request.action == "updateUserInfo"){
                    userService.updateUserInfo(request.message, function(status){
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: status});
                    })
                }

                if(request.action == "listIdentities"){
                    identityService.listIdentities(function(identities){
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: identities});
                    });
                }

                if(request.action == "addIdentity"){
                    identityService.addIdentity(request.message, function(identity){
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: {status:"success",identity: identity}});
                    },
                    function(error){
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: {status:"error", message : error.message}});
                    });
                }

                if(request.action == "generateIdentity"){
                    identityService.generateIdentity(function(identity){
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: identity});
                    });
                }

                if(request.action == "removeIdentity"){
                    identityService.removeIdentity(request.message,function(identity){
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: identity});
                    });
                }

                if(request.action == "removeIdentity"){
                    identityService.removeIdentity(request.message,function(identity){
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: identity});
                    });
                }

                if(request.action == "updateDefaultSubstituteIdentity"){
                    identityService.updateDefaultSubstituteIdentity(request.message,function(identity){
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: identity});
                    });
                }


                if(request.action == "listDomains"){
                    identityService.listDomains(function(availableDomains){
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: availableDomains});
                    });
                }

                if(request.action == "registerUser"){
                    authenticationService.registerUser(request.message.user, function(error){
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: {status:"error",message:error}});
                    },  function(success){
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: {status:"success"}});
                    });
                }

                if(request.action == "listPfbDeals"){
                    pfbService.getActiveDeals(function(deals){
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: deals});
                    });
                }

                if(request.action == "getMyPfbDeals"){
                    pfbService.getMyDeals(function(deals){
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: deals});
                    });
                }

                if(request.action == "acceptPfbDeal"){
                    pfbService.acceptPfbDeal(request.message.serviceId,function(deal){
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: deal});
                    });
                }

                if(request.action == "unsubscribePfbDeal"){
                    pfbService.unsubscribePfbDeal(request.message.serviceId,function(deal){
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: deal});
                    });
                }


                if(request.action == "completeWizard"){
                    privacyWizardService.completeWizard(request.message.currentSetting, request.message.all_suggestions, function(){
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action});
                    });
                }

                if (request.action == "getNextQuestionAndSuggestions") {
                    privacyWizardService.getNextQuestionAndSuggestions(request.message.activeOptions,function (questionAndSuggestions) {
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: questionAndSuggestions});
                    });
                }

                if (request.action == "getOSPSettings") {
                    ospService.getOSPSettings(function (ospSettings) {
                        clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: ospSettings});
                    });
                }

                clientPort.onDisconnect.addListener(function () {
                    clientPort = null;

                });
            });
        }

    }(_port));




});


function login(login_details, securityErrorFunction, successFunction) {
    authenticationService.authenticateUser(login_details, securityErrorFunction, successFunction);
}

function logout(callback) {
    authenticationService.logoutCurrentUser(function () {

        chrome.notifications.create("USER-LOGGED-OUT", {
            type: "basic",
            iconUrl: "/operando/assets/images/icons/operando_logo.png",
            title: "You are logged out!",
            message: "You have successfully logged out! Please give us feedback",
            requireInteraction: true,
            buttons: [{
                title: "Give Feedback"
            },
                {
                    title: "Visit OPERANDO website"
                }]

        }, callback);

    });
}

function getCurrentUser(callback) {
    authenticationService.getCurrentUser(function (user) {
        callback(user);
    })
}

function restoreUserSession(callback) {
    var status = {};

    //TODO refactoring needed here

    if (authenticationService.isLoggedIn() == true) {
        status.success = "success";
        callback(status);
    }
}


authenticationService.restoreUserSession(function () {
    status.success = "success";

}, function () {
    status.fail = "fail";

}, function () {
    status.error = "error";

}, function () {
    status.reconnect = "reconnect";

});

/*

*/