function getParameterByName(name, url) {
    if (!url) {
        url = window.location.href;
    }
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}


privacyPlusApp.controller("confirmUserController", function ($scope, $location, connectionService,$window) {

    $scope.loadingData = true;
    var confirmationCode = getParameterByName("confirmation_code");

    if(confirmationCode){
        connectionService.activateUser(confirmationCode, function (validatedUserSession) {
                $scope.verifyUserStatus = "Email verification successful.";
                $scope.status="success";
                $scope.loadingData = false;
                $scope.$apply();

                Cookies.set("sessionId", validatedUserSession.sessionId);
                Cookies.set("userId", validatedUserSession.userId);

                connectionService.restoreUserSession(function(){
                    messengerService.send("authenticateUserInExtension", {
                        userId: Cookies.get("userId"),
                        sessionId: Cookies.get("sessionId")
                    }, function (status) {
                        successCallback({status: "success"});
                    });
                },function(){
                    console.log("Could not restore user session!");
                });

            },
            function(){
                $scope.verifyUserStatus = "You provided an invalid validation code";
                $scope.status="danger";
                $scope.loadingData = false;
                $scope.$apply();
            });
    }


    $scope.goToDashboard = function(){
        $window.location = "/user-dashboard";
    }

});

angular.element(document).ready(function() {
    angular.bootstrap(document.getElementById('confirm-account'), ['plusprivacy']);
});

