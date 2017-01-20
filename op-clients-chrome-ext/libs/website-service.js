var bus = require("bus-service").bus;
var authenticationService = require("authentication-service").authenticationService;
var portObserversPool = require("observers-pool").portObserversPool;

var websiteService = exports.websiteService = {

    authenticateUserInExtension: function (data) {
        var daysUntilCookieExpire = 1;

        if(data.remember && data.remember === true){
            daysUntilCookieExpire = 365;
        }
        Cookies.set("sessionId", data.sessionId,  { expires: daysUntilCookieExpire });
        Cookies.set("userId", data.userId, { expires: daysUntilCookieExpire });

        authenticationService.restoreUserSession(function () {
            chrome.runtime.openOptionsPage();
        }, function () {
            //status.fail = "fail";

        }, function () {
            //status.error = "error";

        }, function () {
            //status.reconnect = "reconnect";

        });
    },

    getCurrentUserLoggedInInExtension:function(){
        portObserversPool.trigger("getCurrentUserLoggedInInExtension", authenticationService.getUser());
    },

    goToDashboard:function(){
        chrome.runtime.openOptionsPage();
    },

    logout:function(){
        authenticationService.disconnectUser(   function(message){
            portObserversPool.trigger("logout",message);
        });
    },

    loggedIn: function(){
        authenticationService.getCurrentUser(
            function(message){
                portObserversPool.trigger("loggedIn",message);
            }

        );
    }

}
bus.registerService(websiteService);
