var ospApp =  angular.module("ospApp", ['angularModalService', 'ui-notification','ngIntlTelInput',
    'ngMaterial','ngMessages','mdPickers','datatables','ngRoute','oc.lazyLoad']);
ospApp.config(function (NotificationProvider) {
    NotificationProvider.setOptions({
        delay: 10000,
        startTop: 20,
        startRight: 10,
        verticalSpacing: 20,
        horizontalSpacing: 20,
        positionX: 'left',
        positionY: 'bottom'
    })
});

ospApp.filter('timeAgo', [function() {
    return function(object)
    {
        return timeSince(new Date(object));
    }
}]);


ospApp.filter('timestampToDateFormat', [function() {
    return function(object) {
        var d = new Date(object);
        var datestring = ("0" + d.getDate()).slice(-2) + "-" + ("0"+(d.getMonth()+1)).slice(-2) + "-" +
            d.getFullYear();
        return datestring;
    }
}]);

ospApp.filter('isEmpty', [function() {
    return function(object) {
        return angular.equals({}, object);
    }
}]);
ospApp.config(function ($routeProvider) {
   $routeProvider.
       when("/",{
           templateUrl:"../assets/templates/login_osp.html",
       }).
       when("/login",{
           templateUrl:"../assets/templates/login_osp.html"
       }).
       when("/register",{
           templateUrl:"../assets/templates/register_osp.html"
       }).
       when("/offers",{
           templateUrl:"../assets/templates/dashboard/offers.html"
       }).
       when("/deals",{
           templateUrl:"../assets/templates/dashboard/deals.html"
       }).
       otherwise({redirectTo: '/login'});;

});
ospApp
    .config(function (ngIntlTelInputProvider) {
        ngIntlTelInputProvider.set({
            initialCountry: 'gb',
            customPlaceholder: function(selectedCountryPlaceholder, selectedCountryData) {
                return "Phone e.g. " + selectedCountryPlaceholder;
            }
        });
    }).
config(['$locationProvider', function ($locationProvider) {
    $locationProvider.hashPrefix('');
}]);

