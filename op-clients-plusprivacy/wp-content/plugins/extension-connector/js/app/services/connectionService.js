var SERVER_HOST = "plusprivacy.com";
var SERVER_PORT = "8080";
var GUEST_EMAIL = "guest@operando.eu";
var GUEST_PASSWORD = "guest";

privacyPlusApp.service("connectionService",function(swarmService, messengerService){
return {
    activateUser:function(activationCode, successCallback, failCallback){
        swarmService.initConnection(SERVER_HOST, SERVER_PORT, GUEST_EMAIL, GUEST_PASSWORD,
            "plusprivacy-website", "userLogin", function(){
            console.log("reconnect cbk");
            }, function(){
             console.log("connect cbk");
            });

        swarmHub.on("login.js", "success_guest", function guestLoginForUserVerification(swarm) {
            swarmHub.off("login.js", "success_guest", guestLoginForUserVerification);
            if (swarm.authenticated) {
                var  verifyAccountHandler = swarmHub.startSwarm("register.js", "verifyValidationCode", activationCode);
               verifyAccountHandler.onResponse("success", function (swarm) {

                    swarmService.removeConnection();
                    successCallback("success");

                });

                verifyAccountHandler.onResponse("failed", function (swarm) {
                    swarmService.removeConnection();
                    failCallback(swarm.error);
                });
            }
        });
    },

    loginUser:function (user, successCallback, failCallback) {
        swarmService.initConnection(SERVER_HOST, SERVER_PORT, user.email, user.password,
            "plusprivacy-website", "userLogin", function(error) {
            });


        var userLoginSuccess = function (swarm) {
            swarmHub.off("login.js", "success", userLoginSuccess);
            if (swarm.authenticated) {
                messengerService.send("authenticateUserInExtension", {userId: swarm.userId, sessionId: swarm.meta.sessionId, remember: user.remember}, function(status){
                    successCallback({status:"success"});
                });

            }
        }

        var loginFailed = function (swarm) {
            console.log(swarm.error);
            failCallback(swarm.error);
            swarmHub.off("login.js", "success",userLoginSuccess);
            swarmHub.off("login.js", "failed",loginFailed);
        }



        swarmHub.on("login.js", "success", userLoginSuccess);
        swarmHub.on('login.js', "failed", loginFailed);
    },

    getCurrentUser: function(successCbk){
        messengerService.send("getCurrentUserLoggedInInExtension",function(data){
            successCbk(data);
        });
    },

    registerNewUser: function (user, successCallback, failCallback) {
        swarmService.initConnection(SERVER_HOST, SERVER_PORT, GUEST_EMAIL, GUEST_PASSWORD,
            "plusprivacy-website", "userLogin", function(){
                console.log("reconnect cbk");
            }, function(){
                console.log("connect cbk");
            });

        swarmHub.on("login.js", "success_guest", function guestLoginForUserVerification(swarm) {
            swarmHub.off("login.js", "success_guest", guestLoginForUserVerification);
            if (swarm.authenticated) {
                var registerHandler = swarmHub.startSwarm("register.js", "registerNewUser", user);
                registerHandler.onResponse("success", function(swarm){
                    successCallback("success");
                    swarmService.removeConnection();
                });

                registerHandler.onResponse("error", function(swarm){
                    failCallback(swarm.error);
                    swarmService.removeConnection();
                });
            }
        });

    }
    
}

});
