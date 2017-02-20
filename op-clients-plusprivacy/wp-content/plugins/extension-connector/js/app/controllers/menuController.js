menuApp.controller("menuController", function ($scope, SharedService) {

    SharedService.getLocation(function(location){
        $scope.location = location;
        $scope.$apply();
    });

});
