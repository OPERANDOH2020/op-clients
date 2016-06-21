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


angular.module('operando').controller('PreferenceController', ["$scope","$attrs","ModalService",function ($scope, $attrs, ModalService) {
    if ($attrs.socialNetwork) {
        $scope.schema = generateAngularForm($attrs.socialNetwork);


        $scope.form = [];
        for (var key in $scope.schema.properties) {
            $scope.form.push({
                key: key,
                type: "radios"
            })
        }

        $scope.form.push(
            {
                type: "submit",
                title: "Save"
            }
        );

        $scope.model = {};

        $scope.submitPreferences = function(){
            ModalService.showModal({
                templateUrl: '/operando/tpl/modals/not_implemented.html',
                controller:function(){

                }

            }).then(function (modal) {
                modal.element.modal();
            });
        }

    }
}]);
