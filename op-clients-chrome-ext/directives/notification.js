angular.module('notifications', ['ui-notification'])
    .config(function (NotificationProvider) {
        NotificationProvider.setOptions({
            delay: 10000,
            startTop: 20,
            startRight: 10,
            verticalSpacing: 20,
            horizontalSpacing: 20,
            positionX: 'left',
            positionY: 'bottom'
        })
    })
    .factory("notificationService", function ($rootScope, Notification) {


        var notifications = [


            {
                id: 0,
                sender: "WatchDog",
                title: "Add a identity",
                content: "Explain why user should add a identity!",
                action:"identity",
                type: "info-notification"
            },

            {
                id: 2,
                sender: "WatchDog",
                title: "Privacy Questionnaire!",
                content: "Explain why user should take the privacy questionnaire!",
                action:"privacy-questionnaire",
                type: "info-notification"
            },

            {
                id: 3,
                sender: "WatchDog",
                title: "Privacy for Benefits!",
                content: "Explain why user should subscribe!",
                action:"privacy-for-benefits",
                type: "info-notification"
            }

        ];

        /*  var getNotifications = function(){
         return notifications;
         }*/

        var hideNotification = function (notificationId) {
            for (var i = 0; i < notifications.length; i++) {
                if (notifications[i].id == notificationId) {
                    notifications.splice(i, 1);
                    $rootScope.$broadcast("notifications", notifications);
                    break;

                }
            }
        }


        var notifyUserNow = function(){

            var sequence = Promise.resolve();
            notifications.filter(function(notification){
                return notification.type == "info-notification"
                return true;
            }).forEach(function(notification){
                sequence = sequence.then(function () {
                    return new Promise(function (resolve, reject) {

                        Notification(
                            {
                                title: notification.title,
                                message: notification.content,
                                positionY: "top",
                                positionX: "right",
                                delay: "60000",
                                templateUrl: "tpl/notifications/user-notification.html"
                            }, 'warning');

                        setTimeout(function () {
                            resolve();
                        }, 200);
                    })
                })
            });
        }


        return {
            notifications: notifications,
            hideNotification: hideNotification,
            notifyUserNow:notifyUserNow
        }

    });


angular.module('notifications')
    .directive('notificationCounter', function () {
        return {
            restrict: 'E',
            replace: true,
            scope: {},
            link: function ($scope) {

            },
            controller: function ($scope, notificationService) {
                $scope.notifications = {};
                $scope.notifications.counter = notificationService.notifications.length;

                $scope.$on('notifications', function (event, notifications) {
                    console.log(notifications);
                    $scope.notifications.counter = notifications.length;
                });
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
            controller: function ($scope, notificationService) {
                $scope.notifications = notificationService.notifications;

                $scope.$on('notifications', function (event, notifications) {
                    $scope.notifications.counter = notifications;
                });

            },
            templateUrl: '/operando/tpl/notifications/notifications.html'
        }
    })
    .directive('notification', function () {
        return {

            restrict: 'E',
            replace: true,
            scope: {notification: "="},
            link: function ($scope) {

            },
            controller: function ($scope, notificationService, $state ) {

                $scope.hideNotification = function () {
                    notificationService.hideNotification($scope.notification.id);
                }

                $scope.takeAction = function(){
                    switch ($scope.notification.action){
                        case "identity": $state.transitionTo('identityManagement'); break;
                        case "privacy-questionnaire": $state.transitionTo('socialNetworks.privacyQuestionnaire'); break;
                        case "privacy-for-benefits": $state.transitionTo('deals'); break;
                    }
                }
            },
            templateUrl: '/operando/tpl/notifications/notification.html'
        }
    });



