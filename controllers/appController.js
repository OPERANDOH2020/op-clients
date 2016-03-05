angular.module("operando").
controller("appCtrl", ["$scope", "authenticationService", function($scope, authenticationService){

    authenticationService.restoreUserSession(function(){
        console.log("You are authenticated!");
    },function(){
        console.log("You're not authenticated!");
    })

}])
