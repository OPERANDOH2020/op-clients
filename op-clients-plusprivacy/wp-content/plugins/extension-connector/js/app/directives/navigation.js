menuApp.directive("navigation", function( userService, $window){

    return{
        restrict: 'E',
        scope: {
            navigationModel:"=",
            location:"="
        },
        templateUrl: '/wp-content/plugins/extension-connector/js/app/templates/navigation/navbar.html',
        controller: function ($scope) {
            console.log($scope.navigationModel);

            $scope.logout = function () {
                userService.logout(function () {
                    delete[$scope.authenticated];
                    delete[$scope.user];
                    $window.location.reload();
                });
            };

            userService.getUser(function (user) {
                $scope.authenticated = true;
                $scope.user = user;
                $scope.user['authenticated'] = true;
            });
        }
    }

}).directive("menuItem", function(accessService){
    return{
        restrict: 'E',
        replace: true,
        scope: {
            item:"=",
            location:"="
        },
        templateUrl: '/wp-content/plugins/extension-connector/js/app/templates/navigation/menuItem.html',
        controller:function($scope){
            accessService.hasAccess($scope.item.zone, function(access){
                $scope.accessGranted = access;
            });

        }
    }
});
