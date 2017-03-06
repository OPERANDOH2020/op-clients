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
    .factory("notificationService", function ($rootScope, Notification, messengerService,$q) {

       var notifications = [];

        var dismissNotification = function (notificationId, dismissed, callback) {
            messengerService.send("dismissNotification", {notificationId:notificationId, dismissed:dismissed}, function(data){

                notifications = notifications.filter(function( notification ) {
                    console.log(notification);
                    return notification.notificationId !== notificationId;
                });

                $rootScope.$broadcast('notificationCounterUpdate', notifications);
                callback();
            });
        };


        var notifyUserNow = function(){

            var sequence = Promise.resolve();
            notifications.filter(function(notification){
                return notification.type == "info-notification";
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
                        }, 400);
                    })
                })
            });
        };

         function loadUserNotifications(callback) {
             var deferred = $q.defer();
             messengerService.send("getNotifications", function (response) {
                 notifications = response.data;
                 deferred.resolve(notifications);
                 callback(notifications);

             });

             return deferred.promise;
        }

        var getUserNotifications = function(callback){
            loadUserNotifications(callback);
        };

        return {
            dismissNotification: dismissNotification,
            notifyUserNow:notifyUserNow,
            getUserNotifications:getUserNotifications
        }

    });


angular.module('notifications')
    .directive('notificationCounter', function () {
        return {
            restrict: 'E',
            replace: true,
            scope: {},
            controller: function ($scope, notificationService) {
                $scope.notifications = {};
                notificationService.getUserNotifications(function(notifications){
                    $scope.notifications.counter = notifications.length;
                });

                $scope.$on('notificationCounterUpdate', function (event, notifications) {
                    console.log(notifications);
                    $scope.notifications.counter = notifications.length;
                    $scope.$apply();
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
            controller: function ($scope, notificationService, $rootScope) {
                $scope.notifications = [];

                notificationService.getUserNotifications(function(notifications){
                    $scope.notifications = notifications;
                    $rootScope.$broadcast('notificationCounterUpdate', notifications);
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
            controller: function ($scope, notificationService, $state ) {
                    $scope.dismissed = false;
                    $scope.doNotShowNexTime = function () {

                        notificationService.dismissNotification($scope.notification.notificationId, $scope.dismissed, function(){

                        });
                }
                $scope.takeAction = function(action){

                    switch (action.key){
                        case "identity": $state.go('identityManagement'); break;
                        case "privacy-for-benefits": $state.go('deals'); break;
                        case "social-network-privacy":
                            notificationService.dismissNotification($scope.notification.notificationId, true,function(){
                                $state.go('socialNetworks');
                            });
                            break;
                    }
                }
            },
            templateUrl: '/operando/tpl/notifications/notification.html'
        }
    });



