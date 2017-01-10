var bus = require("bus-service").bus;
var authenticationService = require("authentication-service").authenticationService;

var websiteService = exports.websiteService = {

    authenticateUserInExtension: function (data, success_cbk, fail_cbk) {
        var daysUntilCookieExpire = 1;

        if(data.remember && data.remember === true){
            daysUntilCookieExpire = 365;
        }
        Cookies.set("sessionId", data.sessionId,  { expires: daysUntilCookieExpire });
        Cookies.set("userId", data.userId, { expires: daysUntilCookieExpire });

        authenticationService.restoreUserSession(function () {

        }, function () {
            //status.fail = "fail";
            if(fail_cbk){
                fail_cbk();
            }

        }, function () {
            //status.error = "error";

        }, function () {
            //status.reconnect = "reconnect";

        });

        authenticationService.getCurrentUser(function(){
            chrome.runtime.openOptionsPage();
            if(success_cbk){
                success_cbk();
            }
        });
    },

    getCurrentUserLoggedInInExtension:function(callback){
        callback(authenticationService.getUser());
    },

    goToDashboard:function(){
        chrome.runtime.openOptionsPage();
    },

    logout:function(message,callback){
        authenticationService.disconnectUser(callback);
    },

    loggedIn: function(message, callback){
        authenticationService.getCurrentUser(callback);
    }

}
bus.registerService(websiteService);
