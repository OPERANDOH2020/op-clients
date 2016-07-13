angular.module("operando").
controller("readSocialNetworkPrivacySettings", ["$scope", function($scope){
    var osps = getOSPs();

    $scope.osps = [];
    osps.forEach(function(osp){
        $scope.osps.push({
            title:osp,
            settings:getOSPSettings(osp)
        });
    });
}]);



