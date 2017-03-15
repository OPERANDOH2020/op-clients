//var SERVER_HOST = "plusprivacy.com";
var SERVER_HOST = "localhost";
var SERVER_PORT = "8080";
var GUEST_EMAIL = "guest@operando.eu";
var GUEST_PASSWORD = "guest";

angular.module('sharedService').factory("connectionService",function(swarmService, messengerService) {

    var ConnectionService;
    ConnectionService = (function () {

        function ConnectionService() {

        }

        ConnectionService.prototype.activateUser = function (activationCode, successCallback, failCallback) {
            swarmService.initConnection(SERVER_HOST, SERVER_PORT, GUEST_EMAIL, GUEST_PASSWORD,
                "plusprivacy-website", "userLogin", function () {
                    console.log("reconnect cbk");
                }, function () {
                    console.log("connect cbk");
                });

            swarmHub.on("login.js", "success_guest", function guestLoginForUserVerification(swarm) {
                swarmHub.off("login.js", "success_guest", guestLoginForUserVerification);
                if (swarm.authenticated) {
                    var verifyAccountHandler = swarmHub.startSwarm("register.js", "verifyValidationCode", activationCode);
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
        };

        ConnectionService.prototype.loginUser = function (user, userType, successCallback, failCallback) {

            var loginCtor;
            switch (userType){
                case "Public" : loginCtor = "userLogin"; break;
                case "OSP": loginCtor = "ospLogin"; break;
                case "PSP": loginCtor ="pspLogin"; break;
            }

            var self = this;

            swarmService.initConnection(SERVER_HOST, SERVER_PORT, user.email, user.password,
                "plusprivacy-website", loginCtor, function (error) {
                });

            var userLoginSuccess = function (swarm) {
                swarmHub.off("login.js", "success", userLoginSuccess);
                if (swarm.authenticated) {

                    Cookies.set("sessionId", swarm.meta.sessionId, {expires: 1});
                    Cookies.set("userId", swarm.userId, {expires: 1});

                    self.getUser(successCallback);

                    messengerService.send("authenticateUserInExtension", {
                     userId: swarm.userId,
                     sessionId: swarm.meta.sessionId,
                     remember: user.remember
                     }, function (status) {
                        successCallback({status: "success"});
                     });
                }
            };

            var loginFailed = function (swarm) {
                console.log(swarm.error);
                failCallback(swarm.error);
                swarmHub.off("login.js", "success", userLoginSuccess);
                swarmHub.off("login.js", "failed", loginFailed);
            };

            swarmHub.on("login.js", "success", userLoginSuccess);
            swarmHub.on('login.js', "failed", loginFailed);
        };


        ConnectionService.prototype.getUser = function (callback) {
            var getUserHandler = swarmHub.startSwarm('UserInfo.js', 'info');
            getUserHandler.onResponse("result", function (swarm) {
                authenticated = true;
                user = swarm.result;
                if (callback) {
                    callback(user);
                }
            });
        };

        /*used for getting authenticated user in extension*/
        ConnectionService.prototype.getCurrentUser = function (successCbk) {
            messengerService.send("getCurrentUserLoggedInInExtension", function (data) {
                successCbk(data);
            });
        };

        ConnectionService.prototype.registerNewUser = function (user, successCallback, failCallback) {
            swarmService.initConnection(SERVER_HOST, SERVER_PORT, GUEST_EMAIL, GUEST_PASSWORD,
                "plusprivacy-website", "userLogin", function () {
                    console.log("reconnect cbk");
                }, function () {
                    console.log("connect cbk");
                });

            swarmHub.on("login.js", "success_guest", function guestLoginForUserVerification(swarm) {
                swarmHub.off("login.js", "success_guest", guestLoginForUserVerification);
                if (swarm.authenticated) {
                    var registerHandler = swarmHub.startSwarm("register.js", "registerNewUser", user);
                    registerHandler.onResponse("success", function (swarm) {
                        successCallback("success");
                        swarmService.removeConnection();
                    });

                    registerHandler.onResponse("error", function (swarm) {
                        failCallback(swarm.error);
                        swarmService.removeConnection();
                    });
                }
            });
        };

        ConnectionService.prototype.restoreUserSession = function (successCallback, failCallback) {
            var username = Cookies.get("userId");
            var sessionId = Cookies.get("sessionId");
            var self = this;

            /*
            TODO
            I could send the failCallback function, but the SwarmClient should be modified in the future
             */

            var failCallbackPlaceholder = function(){};

            if (!username || !sessionId) {
                failCallback();
            }
            else {
                swarmService.restoreConnection(SERVER_HOST, SERVER_PORT, username, sessionId, failCallbackPlaceholder, failCallbackPlaceholder, function () {
                    console.log("reconnect cbk");
                });
                swarmHub.on('login.js', "restoreSucceed", function restoredSuccessfully(swarm) {

                    self.getUser(successCallback);

                    Cookies.set("sessionId", swarm.meta.sessionId);
                    swarmHub.off("login.js", "restoreSucceed", restoredSuccessfully);
                });

                swarmHub.on('login.js', "restoreFailed", function restoredSuccessfully(swarm) {
                    failCallback();
                    swarmHub.off("login.js", "restoreSucceed", restoredSuccessfully);
                });
            }
        };

        ConnectionService.prototype.logoutCurrentUser = function (callback) {
            console.log("here");
            swarmHub.startSwarm("login.js", "logout");
            swarmHub.on("login.js", "logoutSucceed", function logoutSucceed(swarm) {
                Cookies.remove("userId");
                Cookies.remove("sessionId");
                swarmHub.off("login.js", "logoutSucceed", logoutSucceed);
                swarmService.removeConnection();
                if (callback) {
                    callback();
                }
            });
        };

        ConnectionService.prototype.registerNewOSPOrganisation = function (user, successCallback, failCallback) {
            swarmService.initConnection(SERVER_HOST, SERVER_PORT, GUEST_EMAIL, GUEST_PASSWORD,
                "plusprivacy-website", "userLogin", function () {
                    console.log("reconnect cbk");
                }, function () {
                    console.log("connect cbk");
                });

            swarmHub.on("login.js", "success_guest", function guestLoginForUserVerification(swarm) {
                swarmHub.off("login.js", "success_guest", guestLoginForUserVerification);
                if (swarm.authenticated) {

                    var registerOSPHandler = swarmHub.startSwarm("login.js", "registerNewOSPOrganisation", user);
                    registerOSPHandler.onResponse("success", function (swarm) {
                        successCallback("success");
                        swarmService.removeConnection();
                    });

                    registerOSPHandler.onResponse("error", function (swarm) {
                        failCallback(swarm.error);
                        swarmService.removeConnection();
                    });
                }
            });
        };

        ConnectionService.prototype.getOspRequests = function (successCallback, failCallback) {
            var getRequestsHandler = swarmHub.startSwarm("osp.js", "getRequests");
            getRequestsHandler.onResponse("success", function (swarm) {
                successCallback(swarm.ospRequests);
            });

            getRequestsHandler.onResponse("failed", function (swarm) {
                failCallback(swarm.error);
            });
        };

        ConnectionService.prototype.deleteOSPRequest = function (userId, dismissFeedback, successCallback, failCallback) {
            var getDeleteRequestHandler = swarmHub.startSwarm("osp.js", "removeOSPRequest", userId, dismissFeedback);
            getDeleteRequestHandler.onResponse("success", function (swarm) {
                successCallback();
            });

            getDeleteRequestHandler.onResponse("failed", function (swarm) {
                failCallback(swarm.error);
            });
        };

        ConnectionService.prototype.acceptOSPRequest = function (userId, successCallback, failCallback) {
            var acceptRequestHandler = swarmHub.startSwarm("osp.js", "acceptOSPRequest", userId);
            acceptRequestHandler.onResponse("success", function (swarm) {
                successCallback();
            });

            acceptRequestHandler.onResponse("failed", function (swarm) {
                failCallback(swarm.error);
            });
        };

        ConnectionService.prototype.listOSPs = function (successCallback, failCallback) {
            var listOSPsHandler = swarmHub.startSwarm("osp.js", "listOSPs");
            listOSPsHandler.onResponse("success", function (swarm) {
                successCallback(swarm.ospList);
            });

            listOSPsHandler.onResponse("failed", function (swarm) {
                failCallback(swarm.error);
            });
        };
        ConnectionService.prototype.addOspOffer = function (offerDetails, successCallback, failCallback) {
            var addOspOfferHandler = swarmHub.startSwarm("osp.js", "addOspOffer", offerDetails);
            addOspOfferHandler.onResponse("success", function (swarm) {
                successCallback(swarm.offer);
            });

            addOspOfferHandler.onResponse("failed", function (swarm) {
                failCallback(swarm.error);
            });
        };
        ConnectionService.prototype.deleteOspOffer = function (offerId, successCallback, failCallback) {
            var deleteOspOfferHandler = swarmHub.startSwarm("osp.js", "deleteOspOffer", offerId);
            deleteOspOfferHandler.onResponse("success", function (swarm) {
                successCallback();
            });

            deleteOspOfferHandler.onResponse("failed", function (swarm) {
                failCallback(swarm.error);
            });
        };

        ConnectionService.prototype.listOSPOffers = function (successCallback, failCallback) {
            var listOspOffersHandler = swarmHub.startSwarm("osp.js", "listOSPOffers");
            listOspOffersHandler.onResponse("success", function (swarm) {
                successCallback(swarm.offers);
            });

            listOspOffersHandler.onResponse("failed", function (swarm) {
                failCallback(swarm.error);
            });
        };
        return ConnectionService;

    })();

    if (typeof(window.angularConnectionService) === 'undefined' || window.angularConnectionService === null) {
        window.angularConnectionService = new ConnectionService();
    }

    return window.angularConnectionService;
});

