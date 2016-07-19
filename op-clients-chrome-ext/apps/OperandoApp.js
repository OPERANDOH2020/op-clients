/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    RAFAEL MASTALERU (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

angular.module('operando', ['extensions','identities','pfbdeals','singleClickPrivacy','notifications','osp','angularModalService','operandoCore','schemaForm','ui.router'])
.config( [
    '$compileProvider',
    function( $compileProvider )
    {   //to accept chrome protocol
        $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome|chrome-extension):/);
        $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome|chrome-extension):/);

    }
])

    .run(['$rootScope', '$state', '$stateParams',
        function ($rootScope, $state, $stateParams) {
            $rootScope.$state = $state;
            $rootScope.$stateParams = $stateParams;
        }
    ])
    .config(function($stateProvider, $urlRouterProvider) {
    //
    // For any unmatched url, redirect to /state1
    $urlRouterProvider.otherwise("/home");
    //
    // Now set up the states
    $stateProvider
        .state('home', {
            url: "/home",
            templateUrl: "partials/home.html",
        })
        .state("home.privacyQuestionnaire",{
            url:"/privacy-questionnaire",
            templateUrl:"partials/home/privacy_questionnaire.html"
        })
        .state("home.notifications",{
            url:"/notifications",
            templateUrl:"partials/home/notifications.html"
        })
        .state("home.blog",{
            url:"/blog",
            templateUrl:"partials/home/blog.html"
        })

        .state('preferences', {
            url: "/preferences",
            abstract:true,
            templateUrl: "partials/preferences.html"
        })
        .state('preferences.facebook', {
            url: "/facebook",
            templateUrl: "partials/preferences/facebook.html"
        })
        .state('preferences.linkedin', {
            url: "/linkedin",
            templateUrl: "partials/preferences/linkedin.html"
        })
        .state('preferences.twitter', {
            url: "/twitter",
            templateUrl: "partials/preferences/twitter.html"
        })
        .state('preferences.google', {
            url: "/google",
            templateUrl: "partials/preferences/google.html"
        })
        .state('preferences.abp', {
            url: "/abp",
            templateUrl: "partials/preferences/abp.html"
        })
        .state('preferences.mobile', {
            url: "/mobile",
            templateUrl: "partials/preferences/mobile.html"
        })
        .state('deals', {
            url: "/deals",
            templateUrl: "partials/deals.html",
            abstract:true,
        })
        .state('deals.availableOffers', {
            url: "/offers",
            templateUrl: "partials/deals/available_offers.html"
        })
        .state('deals.myDeals', {
            url: "/my-deals",
            templateUrl: "partials/deals/my_deals.html"
        })
        .state('identityManagement', {
            url: "/identity_management",
            templateUrl: "partials/identity_management.html"
        })
        .state('extensions', {
            url: "/extensions",
            templateUrl: "partials/extensions.html"
        })
        .state('reading-settings', {
            url: "/reading-settings",
            templateUrl: "partials/reading_settings.html"
        })
        .state('account', {
            url: "/account",
            abstract:true,
            templateUrl: "partials/user_account.html"
        })
        .state('account.personal-details', {
            url: "/personal-details",
            templateUrl: "partials/account/personal_details.html"
        })
        .state('account.activity', {
            url: "/activity",
            templateUrl: "partials/account/activity.html"
        })
        .state('account.billing', {
            url: "/billing",
            templateUrl: "partials/account/billing.html"
        });
});
