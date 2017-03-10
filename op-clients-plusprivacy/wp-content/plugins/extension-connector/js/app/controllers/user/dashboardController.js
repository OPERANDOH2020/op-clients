privacyPlusApp.controller("dashboardController", function ($scope, userService,SharedService) {
    userService.getUser(function(user){
        $scope.currentUser = user.email;
        $scope.$apply();
    });

    SharedService.setLocation("userZone");
});
angular.element(document).ready(function() {
    angular.bootstrap(document.getElementById('user_dashboard'), ['plusprivacy']);
});