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
    gotOSPsSettings:[]
};


swarmHub.on("PrivacyWizardSwarm.js", "gotOSPSettings", function (swarm) {
    while (observer.gotOSPsSettings.length > 0) {
        var c = observer.gotOSPsSettings.pop();
        c(swarm.ospSettings);
    }
});


var ospService = exports.ospService = {
    getOSPSettings: function (success_callback) {
        swarmHub.startSwarm('PrivacyWizardSwarm.js', 'getOSPSettings');
        observer.gotOSPsSettings.push(success_callback);
    }
}

