privacyPlusApp.requires.push('datatables');


function AddOspOfferController($scope, $rootScope, close, connectionService, Notification){

    AddOspOfferController.prototype.$scope = $scope;
    AddOspOfferController.prototype.changeInput = function(element){
        var $scope = this.$scope;
        $scope.$apply(function() {
            $scope.icon_file = element.files[0];
            convertImageToBase64($scope.icon_file, function(base64String){
                $scope.offer.logo = base64String;
                $scope.$apply();
            })
        });
    };


    $scope.offer = {};
    $scope.addOspOffer = function(){
        connectionService.addOspOffer($scope.offer, function () {
            $rootScope.$broadcast("newOfferAdded", $scope.offer);

         Notification.success({message: 'OSP request approved!', positionY: 'bottom', positionX: 'center', delay: 2000});
         }, function (error) {
         Notification.error({message: 'An error occurred! Please try again or refresh this page!', positionY: 'bottom', positionX: 'center', delay: 2000});
         });
    };



    $scope.close = function (result) {
        close(result, 500);
    };
}

function OspOffersController ($scope, $rootScope, connectionService, DTColumnDefBuilder,ModalService,Notification){

    $scope.$on("newOfferAdded", function(event, offer){
        console.log(offer);
        if(!$scope.offers){
            $scope.offers = [];
        }
        $scope.offers.push(offer);
        $scope.$apply();
    });


    $scope.$on("offerDeleted", function(event, offerId){

        $scope.offers = $scope.offers.filter(function(offer){
           return offer['offerId'] !== offerId;
        });

        $scope.$apply();
    });

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
        connectionService.listOSPOffers(function(offers){
            $scope.offers = offers;
            $scope.$apply();
        }, function(error){
            $scope.error = error;
            $scope.$apply();
        })
    };

    var restoredSessionFailed = function(){
        alert("failed");
    };

    $scope.addNewOfferModal = function(){
        ModalService.showModal({
            templateUrl: '/wp-content/plugins/extension-connector/js/app/templates/osp/modals/addNewOffer.html',
            controller: AddOspOfferController
        }).then(function (modal) {
            modal.element.modal();
        });
    };


    $scope.deleteOspOffer = function(offerId){
        ModalService.showModal({
            templateUrl: '/wp-content/plugins/extension-connector/js/app/templates/osp/modals/deleteOffer.html',
            controller: function ($scope, close) {
                $scope.deleteOffer = function(){
                    connectionService.deleteOspOffer(offerId, function () {
                        $rootScope.$broadcast("offerDeleted", offerId);
                        Notification.success({message: 'OSP offer successfully removed!', positionY: 'bottom', positionX: 'center', delay: 2000});
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
    }


    connectionService.restoreUserSession(restoredSessionSuccessfully, restoredSessionFailed);
};

privacyPlusApp.controller("ospOffersController", OspOffersController);
