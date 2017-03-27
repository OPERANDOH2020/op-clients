var bus = require("bus-service").bus;
var authenticationService = require("authentication-service").authenticationService;
var portObserversPool = require("observers-pool").portObserversPool;

var websiteService = exports.websiteService = {

    authenticateUserInExtension: function (data) {
        authenticationService.authenticateWithToken(data.userId, data.authenticationToken, function () {
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
        if(authenticationService.isLoggedIn()){
            chrome.runtime.openOptionsPage();
        }
        else{
            portObserversPool.trigger("goToDashboard","sendMeAuthenticationToken");
        }

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

};
bus.registerService(websiteService);
