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
    gotNewQuestion: [],
    wizardCompleted: [],
    suggestedQuestions:[]
}


swarmHub.on("PrivacyWizardSwarm.js", "gotNewQuestion", function (swarm) {
    while (observer.gotNewQuestion.length > 0) {
        var c = observer.gotNewQuestion.pop();
        console.log(swarm);
        c(swarm.question);
    }
});

swarmHub.on("PrivacyWizardSwarm.js", "wizardCompleted", function () {
    while (observer.wizardCompleted.length > 0) {
        var c = observer.wizardCompleted.pop();
        c();
    }
});

swarmHub.on("PrivacyWizardSwarm.js", "gotSuggestedQuestions", function (swarm) {
    while (observer.suggestedQuestions.length > 0) {
        var c = observer.suggestedQuestions.pop();
        console.log(swarm.questions);
        c(swarm.questions);
    }
});



var privacyWizardService = exports.privacyWizardService = {

    getNextQuestion: function (current_setting, success_callback) {
        swarmHub.startSwarm('PrivacyWizardSwarm.js', 'getNextQuestion', current_setting);
        observer.gotNewQuestion.push(success_callback);
        /*
         TODO
         add error callback
         */
    },

    completeWizard: function (current_settings,  provided_suggestions, success_callback) {
        swarmHub.startSwarm('PrivacyWizardSwarm.js', 'completeWizard', current_settings, provided_suggestions);
        observer.wizardCompleted.push(success_callback);
        /*
         TODO
         add error callback
         */
    },

    getSuggestedQuestions : function(options, success_callback){
        swarmHub.startSwarm('PrivacyWizardSwarm.js', 'getSuggestedQuestions', options);
        observer.suggestedQuestions.push(success_callback);
        /*
         TODO
         add error callback
         */
    }
}