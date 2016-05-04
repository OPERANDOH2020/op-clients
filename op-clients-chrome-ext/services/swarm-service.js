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

operandoCore.service("swarmService", function () {

        var swarmConnection = null;
        return {
            getConnection: function () {
                return swarmConnection;
            },
            initConnection: function (host, port, username, password, tenant, ctor, securityErrorFunction, errorFunction, reconnectCbk) {
                if(!swarmConnection){
                    swarmConnection = new SwarmClient(host, port, username, password, tenant, ctor, securityErrorFunction, errorFunction, reconnectCbk);
                    swarmHub.resetConnection(swarmConnection);
                }
                else{
                    swarmConnection.tryLogin( username, password, tenant, ctor, false, securityErrorFunction, errorFunction, reconnectCbk);
                }
            },
            restoreConnection:function(host, port,username, sessionId, securityErrorFunction ,errorFunction, reconnectCbk ){
                swarmConnection = new SwarmClient(host, port, username, sessionId, "chromeBrowserExtension", "restoreSession",securityErrorFunction, errorFunction, reconnectCbk);
                swarmHub.resetConnection(swarmConnection);
            },
            removeConnection:function(){
                swarmConnection.logout();
            }
        }

    });
