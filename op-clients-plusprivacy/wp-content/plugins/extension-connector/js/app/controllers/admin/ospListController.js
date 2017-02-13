privacyPlusApp.requires.push('datatables');

privacyPlusApp.controller("ospListController", ["$scope", "connectionService", "messengerService","DTColumnDefBuilder", function($scope, connectionService, messengerService,DTColumnDefBuilder){


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

    var restoredSessionSuccessfully = function(){
        connectionService.listOSPs(function(ospList){
            $scope.ospList = ospList;
            $scope.$apply();
        }, function(error){
            $scope.error = error;
            $scope.$apply();
        })
    };

    var restoredSessionFailed = function(){
        alert("failed");
    };

    connectionService.restoreUserSession(restoredSessionSuccessfully, restoredSessionFailed);
}]);