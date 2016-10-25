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

var recommenderInitialized = false;
var num_suggestions = 6;
var conditionalProbabilitiesMatrix ;
var initialProbabilities ;
var settingsToOptions = [];
var optionsToSettings = [];
var num_options = 0;

var privacyWizardService = exports.privacyWizardService = {

    completeWizard: function (current_settings,  success_callback) {
        var completeWizardHandler = swarmHub.startSwarm('PrivacyWizardSwarm.js', 'completeWizard', current_settings);
        completeWizardHandler.onResponse("wizardCompleted", function(swarm){
            success_callback();
        })

    },
    getNextQuestionAndSuggestions : function(options, callback) {
        var activeOptions = options.activeOptions;

        if (recommenderInitialized === false) {
            var getNextQuestionAndSuggestionHandler = swarmHub.startSwarm('PrivacyWizardSwarm.js', 'fetchRecommenderParams');

            getNextQuestionAndSuggestionHandler.onResponse("gotRecommenderParams", function(swarm){

                conditionalProbabilitiesMatrix = swarm.recommenderParameters.conditionalProbabilitiesMatrix;
                initialProbabilities = swarm.recommenderParameters.initialProbabilities;
                settingsToOptions = swarm.recommenderParameters.settingsToOptions;
                optionsToSettings = swarm.recommenderParameters.optionsToSettings;
                num_options = optionsToSettings.length;

                recommenderInitialized = true;
                privacyWizardService.getNextQuestionAndSuggestions(activeOptions, callback);

            });
            return;
        }

        if (activeOptions === undefined) {
            activeOptions = [];
        }


        var activations = initialProbabilities.slice();

        activeOptions.forEach(function (activeOption) {
            modifyOption(activations, activeOption, 1);
        });

        var unknownSettings = settingsToOptions.reduce(function (prev, options, setting) {
            var is_known = false;
            options.forEach(function (option) {
                activeOptions.forEach(function (activeOption) {
                    if (option === activeOption) {
                        is_known = true;
                    }
                })
            });
            if (is_known === false) {
                prev.push(setting)
            }
            return prev;
        }, []);


        var questionAndSuggestions = unknownSettings.reduce(function (prev, setting) {

                var options = settingsToOptions[setting];

                var simulationResult = options.reduce(function (prev, currentOption) {
                        modifyOption(activations, currentOption, true);
                        var optionScores = evaluateScoresNaively(activations);
                        var res = extractSuggestions(optionScores, activations, num_suggestions);
                        modifyOption(activations, currentOption, false);

                        prev['suggestions'].push(res['suggestions']);
                        prev['possible_choices_ids'].push(currentOption);
                        prev['confidence'] += optionScores[currentOption] * res['confidence'];

                        return prev;
                    },
                    {
                        "confidence": 0,
                        "suggestions": [],
                        "possible_choices_ids": [],
                        "question_id": setting
                    });


                if (simulationResult['confidence'] > prev['confidence']) {
                    return simulationResult
                } else {
                    return prev;
                }
            }, {
                "confidence": 0
            }
        );

        callback(questionAndSuggestions);

        function evaluateScoresNaively(currentProbabilities) {
            return vecMatrixMultiplication(currentProbabilities, conditionalProbabilitiesMatrix);
        }

        function modifyOption(currentProbabilities, optionToModify, activate) {
            settingsToOptions[optionsToSettings[optionToModify]].forEach(function (option) {
                if (option === optionToModify) {
                    currentProbabilities[option] = activate ? 1 : initialProbabilities[option]
                }
                else {
                    currentProbabilities[option] = activate ? 0 : initialProbabilities[option]
                }
            })
        }

        function extractSuggestions(optionScores, activations, numSuggestions) {
            var suggestions = argSort(optionScores);
            var bestSuggestions = [];
            for (var i = num_options - 1; i >= 0; i--) {
                if (activations[suggestions[i]] === 1 || activations[suggestions[i]] === 0) {
                    continue;
                }
                if (bestSuggestions.some(function (otherSuggestion) {
                        if (optionsToSettings[otherSuggestion] === optionsToSettings[suggestions[i]]) {
                            return true;
                        }
                        return false;
                    }) == false) {
                    bestSuggestions.push(suggestions[i]);
                    if (bestSuggestions.length === numSuggestions) {
                        break;
                    }
                }
            }

            var confidence = bestSuggestions.reduce(function (prev, option) {
                return prev + optionScores[option]
            }, 0);

            return {
                "suggestions": bestSuggestions,
                "confidence": confidence
            }
        }

        function argSort(array){
            //the equivalent of argsort from numpy
            var args = new Array(array.length);
            var argsOfValues = {}
            array.forEach(function (value,index) {
                    if (argsOfValues[value]){
                        argsOfValues[value].push(index);
                    }else{
                        argsOfValues[value] = [index]
                    }
                }
            )
            array.sort();
            array.forEach(function(value,index){
                args[index] = argsOfValues[value].shift();
            });
            return args
        }

        function vecMatrixMultiplication(vector, matrix) {
            var result = new Array(matrix[0].length).fill(0);
            for (var i = 0; i < vector.length; i++) {
                for (var j = 0; j < vector.length; j++) {
                    result[i] += vector[j] * matrix[j][i]
                }
            }
            return result;
        }
    }
};

bus.registerService(privacyWizardService);
