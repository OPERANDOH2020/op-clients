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

var bus = require("bus-service").bus;

var busActions = {
    //TODO refactor this
    login: function(request, clientPort){

        clientPort.onDisconnect.addListener(function () {
            clientPort = null;

        });

        login(request.message.login_details, function () {
            clientPort.postMessage({
                type: "SOLVED_REQUEST",
                action: request.action,
                message: {error: "securityError"}
            });
        }, function () {
            if(clientPort){
                clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: {success: "success"}});
            }
        });
    },

    logout : function (request, clientPort) {

        clientPort.onDisconnect.addListener(function () {
            clientPort = null;

        });

        logout(function () {
            console.log("here");
            if(clientPort){
                clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: {success: "success"}});
            }
        });
    },

    notifyWhenLogout : function(request, clientPort){

        clientPort.onDisconnect.addListener(function () {
            clientPort = null;

        });

        authenticationService.disconnectUser(function(){
            if(clientPort){
                clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: {success: "success"}});
            }
        });
    },

    getCurrentUser: function(request, clientPort){

        clientPort.onDisconnect.addListener(function () {
            clientPort = null;

        });

        getCurrentUser(function (user) {
            if(clientPort){
                clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: user});
            }
        })
    },


    restoreUserSession: function(request, clientPort){

        clientPort.onDisconnect.addListener(function () {
            clientPort = null;

        });

        restoreUserSession(function (status) {
            if(clientPort) {
                clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: status});
            }
        })
    },
    registerUser: function(request, clientPort){

        clientPort.onDisconnect.addListener(function () {
            clientPort = null;

        });

        authenticationService.registerUser(request.message.user, function(error){
            clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: {status:"error",message:error}});
        },  function(success){
            clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: {status:"success"}});
        });
    }

};



chrome.runtime.onConnect.addListener(function (_port) {

    (function(clientPort){

        if (clientPort.name == "OPERANDO_MESSAGER") {

            /**
             * Listen for swarm connection events
             **/

            clientPort.onDisconnect.addListener(function () {
                clientPort = null;

            });

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



                if(busActions[request.action]){
                        var action = busActions[request.action];
                        action(request, clientPort);
                }

                else {
                    if(bus.hasAction(request.action)){
                        var actionFn = bus.getAction(request.action);
                        var args = [];

                        if(request.message!== undefined && (typeof request.message!=="object" && typeof request.message !== null || Object.keys(request.message).length > 0)){
                            args.push(request.message);
                        }

                        args.push(function(data){
                            var response = data;
                            clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: {status:"success", data: response}});
                        });

                        args.push(function(err){
                            clientPort.postMessage({type: "SOLVED_REQUEST", action: request.action, message: {error:err.message}});
                        });

                        actionFn.apply(actionFn, args);

                    } else{
                        console.log("Error: Unable to process action",request.action);
                    }
                }
            });
        }

    }(_port));

});


function login(login_details, securityErrorFunction, successFunction) {
    authenticationService.authenticateUser(login_details, securityErrorFunction, successFunction);
}

function logout(callback) {
    authenticationService.logoutCurrentUser(callback);
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