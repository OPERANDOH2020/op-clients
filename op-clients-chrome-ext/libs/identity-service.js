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


var identities = [];
var observer = {
    generate_identity:{
        success:[],
        error:[]
    },
    add_identity:{
        success:[],
        error:[]
    },
    remove_identity:{
        success:[],
        error:[]
    },
    update_identity:{
        success:[],
        error:[]
    },
    list_identities:{
        success:[],
        error:[]
    },
    updateDefaultSubstituteIdentity:{
        success:[],
        error:[]
    },
    listDomains:{
        success:[],
        error:[]
    }

};

//TODO refactor this
swarmHub.on("identity.js", "createIdentity_success", function (swarm) {

    while (observer.add_identity.success.length > 0) {
        var c = observer.add_identity.success.pop();
        c(swarm.identity);
    }
});

swarmHub.on("identity.js", "createIdentity_error", function (swarm) {
    while (observer.add_identity.error.length > 0) {
        var c = observer.add_identity.error.pop();
        c(swarm.error);
    }
});

swarmHub.on("identity.js", "getMyIdentities_success", function (swarm) {

    while (observer.list_identities.success.length > 0) {
        var c = observer.list_identities.success.pop();
        c(swarm.identities);
    }
});

swarmHub.on("identity.js", "generateIdentity_success", function (swarm) {
    while (observer.generate_identity.success.length > 0) {
        var c = observer.generate_identity.success.pop();
        c(swarm.generatedIdentity);
    }
});


//remove callbacks
swarmHub.on("identity.js", "deleteIdentity_success", function (swarm) {
    while (observer.remove_identity.success.length > 0) {
        var c = observer.remove_identity.success.pop();
        c(swarm.identity);
    }
});


swarmHub.on("identity.js", "deleteIdentity_error", function (swarm) {
    while (observer.remove_identity.error.length > 0) {
        var c = observer.remove_identity.error.pop();
        c(swarm.error);
    }
});

swarmHub.on("identity.js", "defaultIdentityUpdated", function (swarm) {
    while (observer.updateDefaultSubstituteIdentity.success.length > 0) {
        var c = observer.updateDefaultSubstituteIdentity.success.pop();
        c(swarm.identity);
    }
});

swarmHub.on("identity.js", "gotDomains", function (swarm) {
    while (observer.listDomains.success.length > 0) {
        var c = observer.listDomains.success.pop();
        c(swarm.domains);
    }
});



var identityService = exports.identityService = {

    generateIdentity: function (success_callback, error_callback) {
        swarmHub.startSwarm('identity.js', 'generateIdentity');
        observer.generate_identity.success.push(success_callback);
        observer.generate_identity.error.push(error_callback);
    },

    addIdentity: function (identity, success_callback, error_callback) {
        swarmHub.startSwarm('identity.js', 'createIdentity', identity);
        observer.add_identity.success.push(success_callback);
        observer.add_identity.error.push(error_callback);
    },

    removeIdentity: function (identity, success_callback, error_callback) {
        swarmHub.startSwarm('identity.js', 'removeIdentity', identity);
        observer.remove_identity.success.push(success_callback);
        observer.remove_identity.error.push(error_callback);
    },


    listIdentities: function (callback) {
        swarmHub.startSwarm('identity.js', 'getMyIdentities');
        observer.list_identities.success.push(callback);
    },

    updateDefaultSubstituteIdentity:function(identity, callback){
        swarmHub.startSwarm('identity.js', 'updateDefaultSubstituteIdentity', identity);
        observer.updateDefaultSubstituteIdentity.success.push(callback);
    },

    listDomains: function(callback){
        swarmHub.startSwarm('identity.js', 'listDomains');
        observer.listDomains.success.push(callback);
    }
}
