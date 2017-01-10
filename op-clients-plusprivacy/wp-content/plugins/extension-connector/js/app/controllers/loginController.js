privacyPlusApp.controller("loginController", function ($scope, connectionService, messengerService, $window) {

    $scope.authenticationError = false;
    $scope.requestProcessed = false;
    $scope.user = {
        email: "",
        password: ""
    };

    connectionService.getCurrentUser(function(data){
        if(data.data && Object.keys(data.data).length>0){
            $scope.userIsLoggedIn = true;
            $scope.currentUser = data.data.email;
        }
        else{
            $scope.userIsLoggedIn = false;
            messengerService.on("loggedIn", function () {
                $window.location.reload();
            });
        }
        $scope.$apply();
    });

    $scope.submitLoginForm = function () {
        $scope.requestProcessed = true;
        $scope.authenticationError = false;
        connectionService.loginUser($scope.user, function (response) {
                $scope.authenticationError = false;
                $scope.requestProcessed = false;
                $scope.userIsLoggedIn = true;
                connectionService.getCurrentUser(function(data){
                    $scope.currentUser = data.data.email;
                    $scope.$apply();
                });

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
            })
    }

    $scope.goToDashboard = function(){
        messengerService.send("goToDashboard");
    }


    setTimeout(function(){
        var relayResponded = messengerService.extensionIsActive();
        if(relayResponded === false){
            $scope.extension_not_active = true;
            $scope.$apply();
        }
    }, 500);


    messengerService.on("logout", function () {
        $window.location.reload();
    });

});