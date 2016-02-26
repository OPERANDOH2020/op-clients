angular.module('components',[])
    .directive('extensions', function(){
        return{
            restrict: 'E',
            replace: true,
            scope :{},
            link:function($scope){
                $scope.enable = function(){
                    alert("Enable");
                }
            },
            controller:function($scope){

                $scope.extensions = [];


                function getExtensions(){
                    chrome.management.getAll(function (results){
                        results.forEach(function(extension){

                            if(extension.icons && extension.icons  instanceof Array){
                                extension['icon'] = extension.icons.pop();
                                delete extension['icons'];
                            }

                            $scope.extensions.push(extension);
                            $scope.$apply();
                        });

                    });

                    chrome.management.onUninstalled.addListener(function (extension_id){
                        for (var i = 0; i < $scope.extensions.length; i++) {
                            if($scope.extensions[i].id == extension_id){
                                $scope.extensions.splice(i, 1);
                                break;
                            }
                        }
                        $scope.$apply();
                    });
                }

                getExtensions();


            },
            templateUrl:'/operando/tpl/extensions.html'
        }
    })
    .directive('extension', function(ModalService){
        return{
            require:"^extensions",
            restrict: 'E',
            replace: true,
            scope: {extension:"="},
            link:function($scope,element, attrs, extensionsCtrl){

                function switchState(enabled){
                    chrome.management.setEnabled($scope.extension.id, enabled, function(){
                        chrome.management.get($scope.extension.id, function(extension){
                            if(extension.id == $scope.extension.id ){
                                if(extension.icons && extension.icons  instanceof Array){
                                    extension['icon'] = extension.icons.pop();
                                    delete extension['icons'];
                                }
                                $scope.extension = extension;
                                $scope.$apply();
                            }
                        });
                    });
                }

                function uninstall(reason, showConfirmDialog){
                    if(showConfirmDialog === undefined){
                        showConfirmDialog = false;
                    }

                        chrome.management.uninstall($scope.extension.id, {showConfirmDialog: showConfirmDialog}, function () {
                            if (chrome.runtime.lastError) {
                                console.log(chrome.runtime.lastError.message);
                            }
                        });

                }

                $scope.enable = function(){
                    switchState(true);
                }

                $scope.disable = function(){
                    switchState(false);
                }
                $scope.uninstall = function(){
                    uninstall();
                }
                $scope.view_permissions = function () {
                    var permissions = $scope.extension.permissions;
                    var extensionName = $scope.extension.name;
                    var showModal = function (permissionWarnings) {
                        ModalService.showModal({
                            templateUrl: '/operando/tpl/view_permissions.html',
                            controller: function ($scope, close) {
                                $scope.permissions = permissions;
                                $scope.permissionWarnings = permissionWarnings;
                                $scope.name = extensionName;
                                $scope.close = function (result) {
                                    close(result, 500);
                                };
                            }
                        }).then(function (modal) {
                            modal.element.modal();
                        });
                    }
                    chrome.management.getPermissionWarningsById($scope.extension.id, showModal);
                }
            },
            controller:function($scope){
                console.log($scope.extension);
            },
            templateUrl:'/operando/tpl/extension.html'
        }
    });

