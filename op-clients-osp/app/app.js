var ospApp = angular.module("ospApp", ['angularModalService', 'ui-notification', 'ngIntlTelInput',
    'ngMaterial', 'ngMessages', 'mdPickers', 'datatables', 'ngRoute', 'oc.lazyLoad',"chart.js"]);
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

ospApp.filter('timeAgo', [function () {
    return function (object) {
        return timeSince(new Date(object));
    }
}]);


ospApp.filter('timestampToDateFormat', [function () {
    return function (object) {
        var d = new Date(object);
        var datestring = ("0" + d.getDate()).slice(-2) + "-" + ("0" + (d.getMonth() + 1)).slice(-2) + "-" +
            d.getFullYear();
        return datestring;
    }
}]);

ospApp.filter('isEmpty', [function () {
    return function (object) {
        return angular.equals({}, object);
    }
}]);

ospApp
    .config(function (ngIntlTelInputProvider) {
        ngIntlTelInputProvider.set({
            initialCountry: 'gb',
            customPlaceholder: function (selectedCountryPlaceholder, selectedCountryData) {
                return "Phone e.g. " + selectedCountryPlaceholder;
            }
        });
    }).
config(['$locationProvider', function ($locationProvider) {
    $locationProvider.hashPrefix('');
}]);


ospApp.config(function ($routeProvider) {
    $routeProvider.
    when("/", {
        templateUrl: "../assets/templates/landing_page.html"
    }).
    when("/login", {
        templateUrl: "../assets/templates/login_osp.html"
    }).
    when("/register", {
        templateUrl: "../assets/templates/register_osp.html"
    }).
    when("/offers", {
        templateUrl: "../assets/templates/dashboard/offers.html"
    }).
    when("/deals", {
        templateUrl: "../assets/templates/dashboard/deals.html"
    }).
    when("/account", {
        templateUrl: "../assets/templates/dashboard/account.html"
    }).
    when("/certifications", {
        templateUrl: "../assets/templates/dashboard/certifications.html"
    }).
    when("/billing", {
        templateUrl: "../assets/templates/dashboard/billing.html"
    }).
    when("/verify/:verifyCode", {
        templateUrl: "../assets/templates/verify.html"
    }).
    otherwise({redirectTo: '/'});

});


ospApp.run(['$rootScope', '$location', 'userService', function ($rootScope, $location, userService) {

    $rootScope.$on('$routeChangeStart', function (event, next, current) {
        userService.isAuthenticated(function (isAuthenticated) {
            console.log(next, current);

            if (isAuthenticated === false) {
                if (next.$$route.originalPath != "/register" && next.$$route.originalPath != "/login" &&
                    next.$$route.originalPath!='/verify/:verifyCode') {
                    $location.path('/');
                }
            }

        });

    });


}]);



