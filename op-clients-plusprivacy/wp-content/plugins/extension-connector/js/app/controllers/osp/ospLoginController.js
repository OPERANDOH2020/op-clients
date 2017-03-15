privacyPlusApp.controller("ospLoginController", function ($scope, connectionService, messengerService, userService,SharedService,$window) {

    $scope.authenticationError = false;
    $scope.requestProcessed = false;
    $scope.user = {
        email: "",
        password: ""
    };

    $scope.submitLoginForm = function () {
        $scope.requestProcessed = true;
        $scope.authenticationError = false;
        connectionService.loginUser($scope.user, "OSP", function (user) {

                $window.location="/osp-offers";

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

    SharedService.setLocation("ospLogin");

});

angular.element(document).ready(function() {
    angular.bootstrap(document.getElementById('osp_login'), ['plusprivacy']);
});