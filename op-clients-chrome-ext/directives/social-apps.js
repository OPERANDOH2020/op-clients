angular.module('socialApps',['cfp.loadingBar'])
    .directive("socialApps", function (messengerService, ModalService, Notification) {
        return {
            restrict: "E",
            replace: true,
            scope: {sn: "="},
            controller: function ($scope) {
                $scope.requestIsMade = false;
                $scope.apps = [];

                $scope.$on("appRemoved", function(event,appId){
                    $scope.apps = $scope.apps.filter(function(app){
                        return app.appId !== appId;
                    });
                    $scope.$apply();
                });

                $scope.$on("removingApp", function(event,appId){
                    var currentApp = $scope.apps.find(function(app){
                        return app.appId === appId;
                    });
                    currentApp["removing"] = true;
                });

                $scope.removeSocialApp = function(appId){

                    var app = $scope.apps.find(function(app){
                       return app.appId == appId;
                    });

                    app['socialNetwork'] = $scope.sn;

                    ModalService.showModal({
                        templateUrl: '/operando/tpl/modals/removeSocialApp.html',
                        controller:function($scope,$rootScope,cfpLoadingBar){
                            $scope.app = app;

                            $scope.removeApp = function(){
                                $rootScope.$broadcast("removingApp",$scope.app.appId);
                                cfpLoadingBar.start();
                                cfpLoadingBar.inc();
                                messengerService.send("removeSocialApp",{sn:$scope.app.socialNetwork,appId: app.appId},function(response){
                                    cfpLoadingBar.complete();
                                    if(response.status === "success"){
                                        Notification.success({message: "App removed from "+app['socialNetwork'], positionY: 'bottom', positionX: 'center', delay: 5000});
                                        $rootScope.$broadcast("appRemoved",$scope.app.appId);
                                    }
                                });
                            }
                        }

                    }).then(function (modal) {
                        modal.element.modal();
                    });
                };

                messengerService.send("getFacebookApps", function(response){
                    if(response.status == "success"){
                        $scope.apps = response.data;
                        $scope.requestIsMade = true;
                        $scope.$apply();
                    }
                });
            },
            templateUrl:"/operando/tpl/apps/sn_apps.html"
        }
    });
