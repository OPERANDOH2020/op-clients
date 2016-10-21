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
                title: "Privacy Questionnaire!",
                content: "You have not filled the privacy questionnaire yet. Doing so will tailor your social network privacy settings to your preferences.  You can also skip the questionnaire and optimize your social network privacy settings in a single click <a href='#'>Take me to privacy questionnaire</a>. <a href='#'>Take me to single click privacy</a>.",
                action:["privacy-questionnaire","single-click-privacy"],
                type: "info-notification"
            },

            {
                id: 1,
                sender: "WatchDog",
                title: "Add identity",
                content:"You have not yet generated alternative email identities. Doing so will enable you to sign up on websites without disclosing your real email. <a href='#'>Go to email identities.</a>",
                action:"identity",
                type: "info-notification"
            },

            {
                id: 2,
                sender: "WatchDog",
                title: "Privacy deals!",
                content: "You have not yet accepted any privacy deals. Privacy deals enable you to trade some of your privacy for valuable benefits. <a href='#'> Go to deals</a>",
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

                var notificationContent = $scope.notification.content;
                var matchActionLink = /<action-link>([\S\s])*?<\/action-link>/g;
                var match;

                while ((match = matchActionLink.exec(notificationContent)) !== null) {
                    console.log(match);
                }

                    $scope.doNotShowNexTime = function () {
                    //TODO implement this

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
                        case "identity": $state.transitionTo('identityManagement'); break;
                        case "privacy-questionnaire": $state.transitionTo('socialNetworks.privacyQuestionnaire'); break;
                        case "privacy-for-benefits": $state.transitionTo('deals'); break;
                        case "single-click-privacy": $state.transitionTo('socialNetworks'); break;
                    }
                }
            },
            templateUrl: '/operando/tpl/notifications/notification.html'
        }
    });



