angular.module("login",[]).
    directive("loginForm", function(){
    return {
        restrict: 'E',
        replace: true,
        scope: {},
        templateUrl:"/operando/tpl/login/login.html",
        controller:["$scope","messengerService","Notification", function($scope, messengerService,Notification){

            $scope.currentView = "login";

            $scope.login = function(){
                messengerService.send("login", {
                    username: $scope.user.email,
                    password: $scope.user.password
                }, function (response) {
                    if (response.success) {
                        $scope.$apply();
                    }
                    else if (response.error)
                        Notification.error({message: 'Invalid credentials', positionY: 'bottom', positionX: 'center', delay: 2000});
                });
            }

            $scope.recover_password = function(){

            }

            $scope.signup = function(){

            }

            $scope.show_signup = function(){
                $scope.currentView = "signup";
            }

            $scope.show_login = function(){
                $scope.currentView = "login";
            }

            $scope.show_forgot_password = function(){
                $scope.currentView = "forgot_password";
            }
        }]

    }
})
