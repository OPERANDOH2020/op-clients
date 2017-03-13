privacyPlusApp.controller("pspLoginController", function ($scope, connectionService, messengerService, userService,SharedService,$window) {

    $scope.authenticationError = false;
    $scope.requestProcessed = false;
    $scope.user = {
        email: "",
        password: ""
    };

    $scope.submitLoginForm = function () {
        $scope.requestProcessed = true;
        $scope.authenticationError = false;
        connectionService.loginUser($scope.user, "PSP", function (user) {
                $window.location="/psp-dashboard";
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

    SharedService.setLocation("pspLogin");

});

angular.element(document).ready(function() {
    angular.bootstrap(document.getElementById('psp_login'), ['plusprivacy']);
});