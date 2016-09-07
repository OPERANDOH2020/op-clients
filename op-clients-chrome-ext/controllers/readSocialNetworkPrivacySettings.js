angular.module("operando").
controller("readSocialNetworkPrivacySettings", ["$scope","$state","ospService", function($scope, $state, ospService){
    var osps = ospService.getOSPs();

    $scope.osps = [];
    osps.forEach(function(osp){
        $scope.osps.push({
            key:osp.toLowerCase(),
            title:osp,
            settings:ospService.getOSPSettings(osp)
        });
    });

    $scope.isItemIncluded = function (item) {
        return $state.$current.locals.globals.sn === item;
    }
}]);



