privacyPlusApp.requires.push('datatables');

privacyPlusApp.controller("ospRequestsController", ["$scope", "connectionService", "messengerService", "$window", "DTColumnDefBuilder", "ModalService", "Notification",
    function ($scope, connectionService, messengerService, $window, DTColumnDefBuilder, ModalService, Notification) {

    $scope.dtInstance={};

    $scope.dtOptions = {
        "paging": false,
        "searching": false,
        "info":false,
        "order": [[ 0, "asc" ]],
        "columnDefs": [ {
            "targets": 'no-sort',
            "orderable": false
        }]
    };

    $scope.dtColumnDefs = [
        DTColumnDefBuilder.newColumnDef(0),
        DTColumnDefBuilder.newColumnDef(1),
        DTColumnDefBuilder.newColumnDef(2).notSortable(),
        DTColumnDefBuilder.newColumnDef(3).notSortable(),
        DTColumnDefBuilder.newColumnDef(4).notSortable(),
        DTColumnDefBuilder.newColumnDef(5).notSortable()
    ];

    var removeOspRequestFromList = function(userId){
        $scope.ospRequests = $scope.ospRequests.filter(function(ospRequest){
            return ospRequest.userId!==userId;
        });
        $scope.$apply();
    };

    var restoredSessionSuccessfully = function () {
        connectionService.getOspRequests(function (ospRequests) {

            $scope.ospRequests = ospRequests;
            $scope.$apply();

        }, function (error) {
            $scope.error = error;
            $scope.$apply();
        });

        $scope.deleteOSPRequest = function(userId){

            (function(userId){
                ModalService.showModal({
                    templateUrl: '/wp-content/plugins/extension-connector/js/app/templates/osp/modals/denyOspRequest.html',

                    controller: function ($scope, close) {
                        $scope.deleteOspRequest = function(){

                            connectionService.deleteOSPRequest(userId, function () {
                                removeOspRequestFromList(userId);
                                Notification.success({message: 'OSP request successfully removed!', positionY: 'bottom', positionX: 'center', delay: 2000});
                            }, function (error) {
                                Notification.error({message: 'An error occurred! Please try again or refresh this page!', positionY: 'bottom', positionX: 'center', delay: 2000});
                            });
                        };

                        $scope.close = function (result) {
                            close(result, 500);
                        };
                    }
                }).then(function (modal) {
                    modal.element.modal();
                });

            })(userId);
        };

        $scope.acceptOSPRequest = function(userId){
            (function(userId){
                ModalService.showModal({
                    templateUrl: '/wp-content/plugins/extension-connector/js/app/templates/osp/modals/acceptOspRequest.html',

                    controller: function ($scope, close) {
                        $scope.acceptOspRequest = function(){

                            connectionService.acceptOSPRequest(userId, function () {
                                removeOspRequestFromList(userId);
                                Notification.success({message: 'OSP request approved!', positionY: 'bottom', positionX: 'center', delay: 2000});
                            }, function (error) {
                                Notification.error({message: 'An error occurred! Please try again or refresh this page!', positionY: 'bottom', positionX: 'center', delay: 2000});
                            });
                        };

                        $scope.close = function (result) {
                            close(result, 500);
                        };
                    }
                }).then(function (modal) {
                    modal.element.modal();
                });

            })(userId);
        }
    };

    var restoredSessionFailed = function () {
        alert("FAILED");
    };

    //connectionService.restoreUserSession(restoredSessionSuccessfully, restoredSessionFailed);

}]);


angular.element(document).ready(function() {
    angular.bootstrap(document.getElementById('osp-requests'), ['plusprivacy']);
});