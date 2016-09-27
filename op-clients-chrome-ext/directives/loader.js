angular.module('UIComponent').
    directive("uiLoader", function(){
    return {
        restrict: 'E',
        replace: true,
        scope: {},
        templateUrl: '/operando/tpl/ui/loader.html'

    }
})
