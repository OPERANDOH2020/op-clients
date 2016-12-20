var SERVER_HOST = "plusprivacy.com";
var SERVER_PORT = "8080";
var GUEST_EMAIL = "guest@operando.eu";
var GUEST_PASSWORD = "guest";

privacyPlusApp.service("connectionService",function(swarmService){
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
                var  verifyAccountHandler= swarmHub.startSwarm("register.js", "verifyValidationCode", activationCode);
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
    }
}

});
