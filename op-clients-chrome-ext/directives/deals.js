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

angular.module('pfbdeals', [])
    .directive('pfbdeals', ["messengerService", function (messengerService) {
            var templateContent;
            return {
                restrict: 'E',
                replace: true,
                scope: {dealsType: "@"},
                link: function ($scope, element, attrs) {

                    if ($scope.dealsType == "available-deals") {
                        templateContent = '/operando/tpl/deals/pfb-available-deals.html';
                    }
                    else {
                        templateContent = '/operando/tpl/deals/pfb-my-deals.html';
                    }

                },
                controller: function ($scope, $element, $attrs) {
                    $scope.deals = [];

                    if ($scope.dealsType == "available-deals") {
                        messengerService.send("listPfbDeals", {}, function (pfbdeals) {

                            for(var i=0; i<pfbdeals.length; i++){
                                pfbdeals[i].type = "availableOffer";
                            }

                            $scope.deals = pfbdeals;
                            $scope.$apply();
                        });
                    }
                    else if ($scope.dealsType == "my-deals") {
                        messengerService.send("getMyPfbDeals", {}, function (pfbdeals) {

                            for(var i=0; i<pfbdeals.length; i++){
                                pfbdeals[i].type = "myDeal";
                            }

                            $scope.deals = pfbdeals;
                            $scope.$apply();
                        });
                    }

                },
                templateUrl: function(element, attrs) {
                    if(attrs.dealsType=="available-deals"){
                        return '/operando/tpl/deals/pfb-available-deals.html'
                    }
                    else{
                        return '/operando/tpl/deals/pfb-my-deals.html';
                    }
                }
            }
        }]
    )
    .directive('pfbdealRow', function () {
            return {
                require: "^pfbdeals",
                restrict: 'A',
                replace: true,
                scope: {deal: "="},
                controller: ["$scope","messengerService","Notification","$state",function ($scope, messengerService, Notification,$state) {

                    $scope.acceptDeal = function(){
                         messengerService.send("acceptPfbDeal", {serviceId:$scope.deal.serviceId}, function(deal){
                             Notification.success({message:"You have successfully subscribed to deal", positionY: 'bottom', positionX: 'center', delay: 2000});
                             $state.reload();
                         })
                    }

                    $scope.unsubscribeDeal = function(){
                        messengerService.send("unsubscribePfbDeal", {serviceId:$scope.deal.serviceId}, function(deal){
                            Notification.success({message:"You have successfully unsubscribed to deal", positionY: 'bottom', positionX: 'center', delay: 2000});
                            $state.reload();
                        })
                    }

                }],
                templateUrl: '/operando/tpl/deals/pfbdealRow.html'
            }
        }
    );