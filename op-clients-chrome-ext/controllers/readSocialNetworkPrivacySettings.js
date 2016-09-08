angular.module("operando").
controller("readSocialNetworkPrivacySettings", ["$scope", "$state", "ospService", function ($scope, $state, ospService) {
    ospService.getOSPs(function (osps) {
        $scope.osps = [];
        osps.forEach(function (osp) {

            ospService.getOSPSettings(function (settings) {
                $scope.osps.push({
                    key: osp.toLowerCase(),
                    title: osp,
                    settings: settings
                });
            }, osp);

        });

        $scope.isItemIncluded = function (item) {
            return $state.$current.locals.globals.sn === item;
        }
    });
}]);



