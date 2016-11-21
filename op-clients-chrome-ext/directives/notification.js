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

            messengerService.send("dismissNotification", {notificationId:notificationId,dismissed:dismissed}, function(data){
                callback();
            });
        }


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
        }

         function loadUserNotifications(callback) {
            var deferred = $q.defer();
            if (Object.keys(notifications).length > 0) {
                deferred.resolve(notifications);
                callback(notifications);
            }
            else {
                messengerService.send("getNotifications", function(response){
                    var notifications = response.data;
                    deferred.resolve(notifications);
                    callback(notifications);

                });
            }
            return deferred.promise;
        }

        var getUserNotifications = function(callback){
            loadUserNotifications(callback);
        }

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
                    $scope.$apply();
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
            link: function ($scope,element) {

               setTimeout(function(){
                   var actionLinks = element[0].getElementsByClassName('notification_content')[0].getElementsByTagName("a");
                   console.log(actionLinks);

                   actionLinks = [].slice.call(actionLinks);

                   for (var i = 0; i < actionLinks.length; i++) {
                       (function(i){

                           actionLinks[i].addEventListener("click", function(e){
                               e.stopPropagation();
                               $scope.takeAction(i);
                           });
                       })(i);

                   }
               },10);
            },
            controller: function ($scope, notificationService, $state ) {
                    $scope.dismissed = false;
                    $scope.doNotShowNexTime = function () {

                        notificationService.dismissNotification($scope.notification.notificationId, $scope.dismissed, function(){

                        });
                }

                $scope.takeAction = function(index){
                    var nAction;

                    if (Array.isArray($scope.notification.action)) {
                        nAction = $scope.notification.action[index];
                    }
                    else {
                        nAction = $scope.notification.action;
                    }

                    switch (nAction){
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



