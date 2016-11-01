angular.module('UIComponent').
    directive("uiLoader", function(){
    return {
        restrict: 'E',
        replace: true,
        scope: {status:"=?"},
        templateUrl: '/operando/tpl/ui/loader.html',
        controller: function ($scope) {
            if(angular.isDefined($scope.status)){
                switch ($scope.status){
                    case "pending": break;
                    case "completed": break;
                    default: $scope.status = "pending";
                }

            } else{
                $scope.status = "pending";
            }
        }

    }
});
