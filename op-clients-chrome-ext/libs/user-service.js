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


var bus = require("bus-service").bus;

var userUpdatedObservable = swarmHub.createObservable();
var authenticationService = require("authentication-service").authenticationService;

var userService = exports.userService = {
    updateUserInfo: function (user_details, success_callback, error_callback) {
        var updateUserInfoHandler = swarmHub.startSwarm('UserInfo.js', 'updateUserInfo', user_details);
        updateUserInfoHandler.onResponse("updatedUserInfo", function(){
            success_callback();
            authenticationService.setUser(function(){
                userUpdatedObservable.notify();
            });
        });
        updateUserInfoHandler.onResponse("userUpdateFailed", function(response){
            error_callback(response.error);
        })
    },

    changePassword:function(changePasswordData, success_callback, error_callback){
        var changePasswordHandler = swarmHub.startSwarm('UserInfo.js', 'changePassword', changePasswordData.currentPassword, changePasswordData.newPassword);
        changePasswordHandler.onResponse("passwordSuccessfullyChanged", function(response){
            success_callback();
        });

        changePasswordHandler.onResponse("passwordChangeFailure", function(response){
            error_callback(response.error);
        });
    },

    userUpdated : function(callback){
        userUpdatedObservable.observe(function(){
            callback();
        }, true);
    },
    getUserSocialPreferences:function(socialNetwork,success_callback, error_callback){
        var getUserSocialPreferencesHandler =  swarmHub.startSwarm("SocialPreferences.js","getPreferences",socialNetwork);
        getUserSocialPreferencesHandler.onResponse("success", function(response){
            success_callback(response.preferences);
        });

        getUserSocialPreferencesHandler.onResponse("failed", function(response){
            error_callback(response.error);
        })
    },

    saveUserSocialPreferences:function(data, success_callback, error_callback){
        var saveUserSocialPreferencesHandler =  swarmHub.startSwarm("SocialPreferences.js","saveOrUpdatePreferences",data.socialNetwork, data.preferences);
        saveUserSocialPreferencesHandler.onResponse("success", function(response){
            success_callback(response.preferences);
        });

        saveUserSocialPreferencesHandler.onResponse("failed", function(response){
            error_callback(response.error);
        })
    },
    removePreferences:function(preferenceKey, success_callback, error_callback){
        var removePreferencesHandler = swarmHub.startSwarm("SocialPreferences.js","removePreferences",preferenceKey);
        removePreferencesHandler.onResponse("success", function(response){
            success_callback(response);
        });
        removePreferencesHandler.onResponse("failed", function(response){
            error_callback(response.error);
        })
    }


};

bus.registerService(userService);
