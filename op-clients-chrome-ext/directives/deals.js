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
            return {
                restrict: 'E',
                replace: true,
                scope: {dealsType:"@"},

                controller: function ($scope, $element, $attrs) {
                    $scope.deals = [];

                    console.log($scope.dealsType);


                    if($scope.dealsType == "available-deals"){
                        messengerService.send("listPfbDeals",{},function (pfbdeals) {
                            $scope.deals = pfbdeals;
                            $scope.$apply();
                        });
                    }
                    else if($scope.dealsType == "my-deals"){
                        messengerService.send("getMyPfbDeals",{},function (pfbdeals) {
                            console.log($scope.deals);
                            $scope.deals = pfbdeals;
                            $scope.$apply();
                        });
                    }

                },
                templateUrl: '/operando/tpl/pfbdeals.html'
            }
        }]
    )
    .directive('pfbdeal', function () {
            return {
                require: "^pfbdeals",
                restrict: 'E',
                replace: true,
                scope: {deal: "="},
                controller: function ($scope) {

                },
                templateUrl: '/operando/tpl/pfbdeal.html'
            }
        }
    );