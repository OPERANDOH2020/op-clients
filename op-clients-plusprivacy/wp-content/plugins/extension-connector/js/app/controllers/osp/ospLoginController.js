privacyPlusApp.controller("ospLoginController", function ($scope, connectionService, messengerService, userService,SharedService) {

    $scope.authenticationError = false;
    $scope.requestProcessed = false;
    $scope.user = {
        email: "",
        password: ""
    };

    /*userService.isAuthenticated(function(isAuthenticated){
        $scope.userIsLoggedIn = isAuthenticated;
        $scope.$apply();
    });

    userService.getUser(function(user){
        console.log(user);
        $scope.userIsLoggedIn = true;
        $scope.currentUser = user.email;
        $scope.$apply();
    });*/

    $scope.submitLoginForm = function () {
        $scope.requestProcessed = true;
        $scope.authenticationError = false;
        connectionService.loginUser($scope.user, "OSP", function (user) {
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

    SharedService.setLocation("ospLogin");

});

angular.element(document).ready(function() {
    angular.bootstrap(document.getElementById('osp_login'), ['plusprivacy']);
});