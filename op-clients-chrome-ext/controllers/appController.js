/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    RAFAEL MASTALERU (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */


angular.module("operando").
controller("appCtrl", ["$scope", "messengerService","$window","notificationService", function ($scope, messengerService,$window, notificationService) {

    $scope.userIsLoggedIn = false;

    $scope.logout = function () {
        messengerService.send("logout", {}, function () {
            $scope.userIsLoggedIn = false;
            $window.location.href = "http://b2c.operando.eu";
        });
    }

        messengerService.send("getCurrentUser",{}, function(user){
            $scope.user = user;
            $scope.userIsLoggedIn = true;
            $scope.$apply();

            checkNotifications($scope.user.userId);

        });

        messengerService.send("notifyWhenLogout", {}, function () {
            //$scope.userIsLoggedIn = false;
            //$scope.$apply();
            $window.location.href = "http://b2c.operando.eu";
        });



    function checkNotifications(userId){

        //TODO check notifications from server
        chrome.storage.local.get("user_notifications", function(notifications){
            console.log(notifications);
            if(Object.keys(notifications).length>0){

                if(notifications.user_notifications.indexOf(userId)=== -1){
                    setTimeout(function(){
                        notifications.user_notifications.push(userId);
                        notificationService.notifyUserNow();

                        chrome.storage.local.set(notifications);
                    },2000);

                }
            }
            else{
                setTimeout(function(){
                    notificationService.notifyUserNow();
                    var notifications = {
                        user_notifications: [userId]

                    }
                    chrome.storage.local.set(notifications);
                },2000);

            }
        })
    }

}]);


