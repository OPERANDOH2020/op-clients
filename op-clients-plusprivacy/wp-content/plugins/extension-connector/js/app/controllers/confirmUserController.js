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



privacyPlusApp.controller("confirmUserController", function ($scope, $location, connectionService) {

    $scope.loadingData = true;
    var confirmationCode = getParameterByName("confirmation_code");

    if(confirmationCode){
        connectionService.activateUser(confirmationCode, function (message) {
                $scope.verifyUserStatus = "Email verification successful.";
                $scope.status="success";
                $scope.loadingData = false;
                $scope.$apply();
            },
            function(){
                $scope.verifyUserStatus = "You provided an invalid validation code";
                $scope.status="danger";
                $scope.loadingData = false;
                $scope.$apply();
            });
    }

});
