angular.module("op-popup").
    controller("loginCtrl", ["$scope", "authenticationService", function($scope, authenticationService){

    $scope.user = {};
    $scope.authError = null;
    $scope.loginAreaState = "loggedout";

    //show login form
    $scope.show_login = function () {
        $scope.loginAreaState = "login_form";
    }

    $scope.cancel = function () {
        $scope.loginAreaState = "loggedout";
    }


    $scope.login = function() {

        var securityErrorFunction = function (err, data) {
            $scope.authError = 'Invalid user or password...';
            $scope.$apply();
        }

        var errorFunction = function (err) {
            $scope.status = 'Invalid connection...';
            $scope.$apply();
        }

        var successFunction = function () {
            $scope.loginAreaState = "loggedin";
        }

        authenticationService.authenticateUser($scope.user.email, $scope.user.password, securityErrorFunction, errorFunction, successFunction);

    }


    $scope.logout = function(){
        authenticationService.logoutCurrentUser(function(){
            $scope.loginAreaState = "loggedout";
            $scope.$apply()
        });
    }

    $scope.manage_accounts = function(){
        window.open(chrome.runtime.getURL("operando/operando.html#identity_management_tab"),"operando");
    }

    authenticationService.restoreUserSession(function () {
            $scope.loginAreaState = "loggedin";
            $scope.$apply();
        },
        function () {
            $scope.loginAreaState = "loggedout";
        });


    authenticationService.getCurrentUser(function(user){
        $scope.user.username = user.userName;
        $scope.$apply();
    });









}]);
