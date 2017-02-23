angular.module('sharedService', []).factory('SharedService', function () {

    var SharedService;
    SharedService = (function () {
        var location;
        var locationSet = false;
        var locationCallbacks = [];

        function SharedService() {

        }

        SharedService.prototype.setLocation = function (_location) {
            if (locationSet === true) {
                return new Error("locationAlreadySet");
            }
            else {
                location = _location;
                locationSet = true;
                locationCallbacks.forEach(function (callback) {
                    callback(location);
                });
            }
        };

        SharedService.prototype.getLocation = function (callback) {
            if (location) {
                callback(location);
            }
            else {
                locationCallbacks.push(callback);
            }
        };
        return SharedService;
    })();

    if (typeof(window.angularSharedService) === 'undefined' || window.angularSharedService === null) {
        window.angularSharedService = new SharedService();
    }
    return window.angularSharedService;
});

/*angular.module('sharedService').run(["connectionService", "userService", function (connectionService, userService) {
        //console.log("HERE");
        var restoredSessionSuccessfully = function (user) {
            userService.setUser(user);
            userService.getUser(function(user){
                console.log(user);
            });
        };

        var restoredSessionFailed = function () {
            userService.removeUser();
        };
        connectionService.restoreUserSession(restoredSessionSuccessfully, restoredSessionFailed);
    }]);
*/