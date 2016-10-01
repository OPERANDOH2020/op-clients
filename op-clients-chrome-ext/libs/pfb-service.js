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
    gotActiveDealsCallbacks:[],
    gotMyDealsCallbacks:[],
    acceptDealCallbacks:[],
    unsubscribeDealCallbacks:[]
};


swarmHub.on("pfb.js", "gotActiveDeals", function (swarm) {

    while (observer.gotActiveDealsCallbacks.length > 0) {
        var c = observer.gotActiveDealsCallbacks.pop();
        c(swarm.deals);
    }
});

swarmHub.on("pfb.js", "gotMyDeals", function (swarm) {
    while (observer.gotMyDealsCallbacks.length > 0) {
        var c = observer.gotMyDealsCallbacks.pop();
        c(swarm.deals);
    }
});

swarmHub.on("pfb.js", "dealAccepted", function (swarm) {
    while (observer.acceptDealCallbacks.length > 0) {
        var c = observer.acceptDealCallbacks.pop();
        c(swarm.deal);
    }
});

swarmHub.on("pfb.js", "dealUnsubscribed", function (swarm) {
    while (observer.unsubscribeDealCallbacks.length > 0) {
        var c = observer.unsubscribeDealCallbacks.pop();
        c(swarm.deal);
    }
});


var pfbService = exports.pfbService = {

    getActiveDeals: function (success_callback) {
        swarmHub.startSwarm('pfb.js', 'getActiveDeals');
        observer.gotActiveDealsCallbacks.push(success_callback);
    },

    getMyDeals: function (success_callback) {
        swarmHub.startSwarm('pfb.js', 'getMyDeals');
        observer.gotMyDealsCallbacks.push(success_callback);
    },

    acceptPfbDeal: function(pfbDealId, success_callback){
        swarmHub.startSwarm("pfb.js", "acceptDeal", pfbDealId);
        observer.acceptDealCallbacks.push(success_callback);
    },

    unsubscribePfbDeal: function(pfbDealId, success_callback){
        swarmHub.startSwarm("pfb.js", "unsubscribeDeal", pfbDealId);
        observer.unsubscribeDealCallbacks.push(success_callback);
    }

}

