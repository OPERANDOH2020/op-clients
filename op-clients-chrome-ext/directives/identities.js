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


angular.module('identities', [])
    .directive('identities', ["messengerService", function (messengerService) {
            return {
                restrict: 'E',
                replace: true,
                scope: {},

                controller: function ($scope, ModalService) {
                    $scope.identities = [];



                    messengerService.send("getCurrentUser",{}, function(user){
                        $scope.user = user;
                        $scope.$apply();
                    });


                    var refreshIdentities = function () {
                        $scope.$apply();
                    }

                    messengerService.send("listIdentities",{},function (identities) {
                        $scope.identities = identities;
                        refreshIdentities();
                    });


                    $scope.$on('refreshIdentities',function() {
                        messengerService.send("listIdentities",{},function (identities) {
                            $scope.identities = identities;
                            refreshIdentities();
                        });
                    });

                    $scope.$on('changedDefaultSID',function(defaultIdentity) {
                        $scope.identities.forEach(function(identity){

                            if(identity.email != defaultIdentity.email){
                                identity.isDefault = false;
                            }
                        });
                    });


                    $scope.add_new_sid = function () {
                        var identities = $scope.identities;
                        ModalService.showModal({
                            templateUrl: '/operando/tpl/modals/add_sid.html',
                            controller: ["$scope", "$element", "close", "messengerService","Notification", function ($scope, $element, close, messengerService, Notification) {

                                $scope.identity = {};
                                $scope.domains = {};

                                messengerService.send("listDomains",{},function(domains){
                                    $scope.domains.availableDomains = domains;
                                    $scope.identity.domain = $scope.domains.availableDomains[0];
                                    $scope.generateIdentity();
                                });

                                $scope.saveIdentity = function () {
                                    messengerService.send("addIdentity",$scope.identity, function (response) {

                                        if(response.status == "success"){
                                            identities.push(response.identity);
                                            refreshIdentities();
                                            $scope.close(response.identity);
                                        }
                                        else{
                                            Notification.error({message:response.message, positionY: 'bottom', positionX: 'center', delay: 2000});
                                        }

                                    });
                                }


                                $scope.generateIdentity = function(){
                                    messengerService.send("generateIdentity",{},function(generatedIdentity){
                                        console.log(generatedIdentity);
                                        $scope.identity.alias = generatedIdentity.email;
                                        $scope.refreshSID();
                                        $scope.$apply();
                                    },
                                    function(){
                                        Notification.error({message:error.message,positionY: 'bottom', positionX: 'center', delay: 2000});
                                    })
                                }

                                $scope.refreshSID = function(){
                                    $scope.identity.email = $scope.identity.alias+"@"+$scope.identity.domain.name;
                                }

                                $scope.close = function (result) {
                                    $element.modal('hide');
                                    close(result, 500);
                                };

                            }]
                        }).then(function (modal) {
                            modal.element.modal();
                        });
                    }
                },
                templateUrl: '/operando/tpl/identities.html'
            }
        }]
    )
    .directive('identityRow', function () {
            return {
                require: "^identities",
                restrict: 'A',
                replace: true,
                scope: {identity: "="},
                controller: function ($scope, ModalService, messengerService, Notification) {

                    $scope.changeDefaultIdentity = function(){

                        messengerService.send("updateDefaultSubstituteIdentity",$scope.identity, function(){
                            $scope.$parent.$emit("changedDefaultSID",$scope.identity);
                            $scope.identity.isDefault = true;
                            Notification.success({message:"You're default identity is set to "+$scope.identity.email, positionY: 'bottom', positionX: 'center', delay: 2000});

                        });
                    }

                    $scope.removeIdentity = function () {
                        var identity = $scope.identity;
                        var emitToParent = function(event){
                            $scope.$emit(event);
                        }

                        ModalService.showModal({

                            templateUrl: '/operando/tpl/modals/delete_sid.html',
                            controller: ["$scope", "close", "messengerService", function ($scope, close, messengerService) {
                                $scope.identity = identity;
                                $scope.deleteIdentity = function(){
                                    messengerService.send("removeIdentity",identity, function(identity){
                                        Notification.success({message:"Identity "+identity.email+" was successfully deleted!",positionY: 'bottom', positionX: 'center', delay: 2000});
                                        emitToParent("refreshIdentities");

                                    },
                                    function(error){
                                        Notification.error({message:error.message,positionY: 'bottom', positionX: 'center', delay: 2000});
                                   })
                                }

                                $scope.close = function (result) {
                                    close(result, 500);
                                };
                            }
                            ]
                        }).then(function (modal) {
                            modal.element.modal();
                        })
                    }
                    
                },
                templateUrl: '/operando/tpl/identityRow.html'
            }
        }
    );