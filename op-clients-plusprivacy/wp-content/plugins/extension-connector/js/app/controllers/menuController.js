menuApp.controller("menuController", function ($scope, SharedService, userService,$window) {

    SharedService.getLocation(function(location){
        $scope.location = location;
        $scope.$apply();
    });

    userService.getUser(function(user){
        $scope.authenticated = true;
        $scope.user = user;
        $scope.user['authenticated'] = true;
        $scope.$apply();
    });


    $scope.logout = function(){
        userService.logout(function(){
            delete[$scope.authenticated];
            delete[$scope.user];
            $window.location.reload();
        });
    }

});
