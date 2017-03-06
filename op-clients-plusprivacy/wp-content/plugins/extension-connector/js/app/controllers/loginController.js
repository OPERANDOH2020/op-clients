privacyPlusApp.controller("loginController", function ($scope, connectionService, messengerService, userService, $window) {

    $scope.authenticationError = false;
    $scope.requestProcessed = false;
    $scope.user = {
        email: "",
        password: ""
    };

    userService.isAuthenticated(function(isAuthenticated){
        $scope.userIsLoggedIn = isAuthenticated;

    });

    userService.getUser(function(user){
        $scope.userIsLoggedIn = true;
        $scope.currentUser = user.email;
        $scope.$apply();
    });

    $scope.submitLoginForm = function () {
        $scope.requestProcessed = true;
        $scope.authenticationError = false;
        connectionService.loginUser($scope.user, function (user) {
                userService.setUser(user);
                $scope.authenticationError = false;
                $scope.requestProcessed = false;
                $scope.userIsLoggedIn = true;

                $scope.$apply();

            },
            function (error) {

            if(error == "account_not_activated"){
                    $scope.errorResponse = "Account not activated!";
                }
                else{
                    $scope.errorResponse = "Invalid credentials!";
                }

                $scope.requestProcessed = false;
                $scope.authenticationError = true;
                $scope.$apply();
            });
    };

    $scope.goToDashboard = function(){
        messengerService.send("goToDashboard");
    };

    setTimeout(function(){
        var relayResponded = messengerService.extensionIsActive();
        if(relayResponded === false){
            $scope.extension_not_active = true;
            $scope.$apply();
        }
    }, 1000);

    /*messengerService.on("logout", function () {
        $window.location.reload();
    });*/
});

angular.element(document).ready(function() {

    /*var $inj = angular.injector(['sharedService']);
    var MenuLocatorService = $inj.get('SharedService');
    MenuLocatorService.setLocation("login");*/
    angular.bootstrap(document.getElementById('login'), ['plusprivacy']);

});