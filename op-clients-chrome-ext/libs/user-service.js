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


var observer = {
    updateUserInfoCallbacks:[]
};


swarmHub.on("UserInfo.js", "updatedUserInfo", function (swarm) {
    while (observer.updateUserInfoCallbacks.length > 0) {
        var c = observer.updateUserInfoCallbacks.pop();
        c(swarm);
    }
});


var userService = exports.userService = {
    updateUserInfo: function (user_details, success_callback) {
        swarmHub.startSwarm('UserInfo.js', 'updateUserInfo', user_details);
        observer.updateUserInfoCallbacks.push(success_callback);

    }
}
