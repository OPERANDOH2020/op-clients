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

/*ext.onMessage.addListener(function(msg, sender, sendResponse)
{
    switch (msg.action)
    {
        case "login":
            alert("login");
            break;
        case "logout":
            alert("logout");
    }
});*/


var port;

chrome.runtime.onConnect.addListener(function (_port) {
    port =_port;

    if (port.name == "OPERANDO_MESSAGER") {
        port.onMessage.addListener(function (request) {

            if (request.action == "login" && request.message) {
                login(request.message.username, request.message.password, function () {
                    port.postMessage({
                        type: "SOLVED_REQUEST",
                        action: request.action,
                        message: {error: "securityError"}
                    });
                }, function () {
                    port.postMessage({type: "SOLVED_REQUEST", action: request.action, message: {success: "success"}});
                });
            }

            if (request.action == "logout") {
                logout(function () {
                    port.postMessage({type: "SOLVED_REQUEST", action: request.action, message: {success: "success"}});
                });
            }

            if (request.action == "getCurrentUser") {
                getCurrentUser(function (user) {
                    port.postMessage({type: "SOLVED_REQUEST", action: request.action, message: user});
                })
            }

            if (request.action == "restoreUserSession") {
                restoreUserSession(function (status) {
                    port.postMessage({type: "SOLVED_REQUEST", action: request.action, message: status});
                })
            }

        });
    }

    port.onDisconnect.addListener(function(){
       port = null;

    });

});


function login(username, password, securityErrorFunction, successFunction) {
    authenticationService.authenticateUser(username, password, securityErrorFunction, successFunction);
}

function logout(callback) {
    authenticationService.logoutCurrentUser(function () {
        callback();
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
