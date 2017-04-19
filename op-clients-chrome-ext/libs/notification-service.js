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

var notificationService = exports.notificationService = {

    getNotifications: function (callback) {

        var getNotificationHandler = swarmHub.startSwarm('notification.js', 'getNotifications');
        getNotificationHandler.onResponse("gotNotifications", function(swarm){
            callback(swarm.notifications);
        });
    },

    dismissNotification:function(notificationData, callback){
        var dismissNotificationHandler = swarmHub.startSwarm("notification.js", "dismissNotification", notificationData.notificationId);
        dismissNotificationHandler.onResponse("notificationDismissed", function(){
            callback();
        })

    }
}
bus.registerService(notificationService);