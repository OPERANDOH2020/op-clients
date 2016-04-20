operandoCore.service("swarmService", function () {

        var swarmConnection = null;
        return {
            getConnection: function () {
                return swarmConnection;
            },
            initConnection: function (host, port, username, password, tenant, ctor, securityErrorFunction, errorFunction) {
                if(!swarmConnection){
                    swarmConnection = new SwarmClient(host, port, username, password, tenant, ctor, securityErrorFunction, errorFunction);
                    swarmHub.resetConnection(swarmConnection);
                }
                else{
                    swarmConnection.tryLogin( username, password, tenant, ctor, false, securityErrorFunction, errorFunction);
                }
            },
            restoreConnection:function(host, port,username, sessionId, securityErrorFunction ,errorFunction ){
                swarmConnection = new SwarmClient(host, port, username, {sessionId:sessionId}, "chromeBrowserExtension", "restoreSession",securityErrorFunction, errorFunction);
                swarmHub.resetConnection(swarmConnection);
            },
            removeConnection:function(){
                swarmConnection.logout();
            }
        }

    });
