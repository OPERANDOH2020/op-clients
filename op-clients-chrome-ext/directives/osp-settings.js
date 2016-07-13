angular.module('osp', [])
    .directive('ospSettings', function () {
        return {
            restrict: 'E',
            replace: false,
            scope: {config:"="},


            controller: function ($scope) {

            },

            templateUrl: '/operando/tpl/osp/osps.html'
        }
    })
    .directive('ospSetting', function () {
        return {
            restrict: 'E',
            replace: false,
            scope: {
                settingKey: "=",
                settingValue: "="
            },
            require:"^ospSettings",


            controller: function ($scope) {

                console.log($scope.settingValue.name);

            },
            templateUrl: '/operando/tpl/osp/osp.html'
        }
    })
    .directive('readSnSettings', function(){
        return {
            restrict: "E",
            replace:false,
            scope:{
                osp:"="
            },
            controller: function ($scope) {
                $scope.readSocialNetworkPrivacySettings = function(){

                    /*
                    TODO
                    start reading settings
                     */
                    /*
                    after finishing show them
                     */


                }
            },
            templateUrl: '/operando/tpl/osp/read_settings_btn.html'

        }
    });
