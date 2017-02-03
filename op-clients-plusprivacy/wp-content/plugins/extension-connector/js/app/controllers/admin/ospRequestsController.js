privacyPlusApp.requires.push('datatables');

privacyPlusApp.controller("ospRequestsController", function ($scope, connectionService, messengerService, $window, DTColumnDefBuilder, DTOptionsBuilder) {

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


    var restoredSessionSuccessfully = function () {
        connectionService.getOspRequests(function (ospRequests) {

            $scope.ospRequests = ospRequests;
            $scope.$apply();

        }, function (error) {
            $scope.error = error;
            $scope.$apply();
        });


        /*connectionService.getCurrentUser(function (data) {
         if (data.data && Object.keys(data.data).length > 0) {
         $scope.userIsLoggedIn = true;
         }
         else {
         $scope.userIsLoggedIn = false;
         messengerService.on("loggedIn", function () {
         $window.location.reload();
         });
         }
         $scope.$apply();
         });

         setTimeout(function () {
         var relayResponded = messengerService.extensionIsActive();
         if (relayResponded === false) {
         $scope.extension_not_active = true;
         $scope.$apply();
         }
         }, 500);

         messengerService.on("logout", function () {
         $window.location.reload();
         });*/
    };

    var restoredSessionFailed = function () {
        alert("FAILED");
    };

    connectionService.restoreUserSession(restoredSessionSuccessfully, restoredSessionFailed);

});