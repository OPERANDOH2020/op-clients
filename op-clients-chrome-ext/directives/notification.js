angular.module('notifications', [])
    .directive('notificationCounter', function () {
        return {
            restrict: 'E',
            replace: true,
            scope: {},
            link: function ($scope) {

            },
            controller: function ($scope) {
                $scope.notifications = {};
                $scope.notifications.counter = 3;
            },
            templateUrl: '/operando/tpl/notifications/notification-counter.html'
        }
    });


angular.module('notifications').
    directive('notifications', function () {
        return {
            restrict: 'E',
            replace: true,
            scope: {},
            link: function ($scope) {

            },
            controller: function ($scope) {
                $scope.notifications = [{
                    title: "Some information"
                },
                {
                    title: "Some information 1"
                },
                {
                    title: "Some information 2"
                }];

                $scope.notifications.counter = $scope.notifications.length;
            },
            templateUrl: '/operando/tpl/notifications/notifications.html'
        }
    })
    .directive('notification', function () {
        return {
            require: "^notifications",
            restrict: 'E',
            replace: true,
            scope: {},
            link: function ($scope) {

            },
            controller: function ($scope) {


            },
            templateUrl: '/operando/tpl/notifications/notification.html'
        }
    })



