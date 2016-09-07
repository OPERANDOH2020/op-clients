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
    onWizardCompleted: [],
    onReccomenderParameters:[]
}

var reccomenderInitialized = false;

var num_suggestions = 9;
var conditionalProbabilitiesMatrix ;
var initialProbabilities ;
var settingsToOptions = [];
var optionsToSettings = [];
var num_options = 0;


swarmHub.on("PrivacyWizardSwarm.js", "wizardCompleted", function () {
    while (observer.onWizardCompleted.length > 0) {
        var c = observer.onWizardCompleted.pop();
        c();
    }
});

swarmHub.on("PrivacyWizardSwarm.js", "gotReccomenderParams", function (swarm) {
    conditionalProbabilitiesMatrix = swarm.reccomenderParameters.conditionalProbabilitiesMatrix;
    initialProbabilities = swarm.reccomenderParameters.initialProbabilities;
    settingsToOptions = swarm.reccomenderParameters.settingsToOptions;
    optionsToSettings = swarm.reccomenderParameters.optionsToSettings;
    num_options = optionsToSettings.length;
    reccomenderInitialized = true;
    
    while (observer.onWizardCompleted.length > 0) {
        var c = observer.onReccomenderParameters.pop();
        c();
    }
});




var privacyWizardService = exports.privacyWizardService = {
    completeWizard: function (current_settings,  provided_suggestions, success_callback) {
        swarmHub.startSwarm('PrivacyWizardSwarm.js', 'completeWizard', current_settings, provided_suggestions);
        observer.onWizardCompleted.push(success_callback);
    },
    getNextQuestionAndSuggestions : function(activeOptions,callback) {

        if (reccomenderInitialized === false) {
            swarmHub.startSwarm('PrivacyWizardSwarm.js', 'fetchReccomenderParams');
            observer.onReccomenderParameters.push(function () {
                privacyWizardService.getNextQuestionAndSuggestions(activeOptions, callback);
            });
            return;
        }

        if (activeOptions === undefined) {
            activeOptions = [];
        }


        var activations = optionProbabilities.slice();

        activeOptions.forEach(function (activeOption) {
            modifyOption(activations, activeOption, 1);
        });

        var unknownSettings = settingToOptions.reduce(function (prev, options, setting) {
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
                var options = settingToOptions[setting];

                var simulationResult = options.reduce(function (prev, currentOption) {
                        modifyOption(activations, currentOption, true);
                        var optionScores = evaluateScoresNaively(activations);
                        var res = extractSuggestions(optionScores, activations, numSuggestions);
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
            return vecMatrixMultiplication(currentProbabilities, conditionalProbabilities);
        }

        function modifyOption(currentProbabilities, optionToModify, activate) {
            settingToOptions[optionToSetting[optionToModify]].forEach(function (option) {
                if (option === optionToModify) {
                    currentProbabilities[option] = activate ? 1 : optionProbabilities[option]
                }
                else {
                    currentProbabilities[option] = activate ? 0 : optionProbabilities[option]
                }
            })
        }

        function extractSuggestions(optionScores, activations, numSuggestions) {
            var suggestions = utils.argSort(optionScores);
            var bestSuggestions = [];
            for (var i = numOptions - 1; i >= 0; i--) {
                if (activations[suggestions[i]] === 1 || activations[suggestions[i]] === 0) {
                    continue;
                }
                if (bestSuggestions.some(function (otherSuggestion) {
                        if (optionToSetting[otherSuggestion] === optionToSetting[suggestions[i]]) {
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
