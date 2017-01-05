privacyPlusApp.service("messengerService",function(){

    var callbacks = {};
    var events = {};
    var relayIsReady = false;
    var waitingMessages = [];


    function relayMessage(message){

        if(relayIsReady){
            window.postMessage(message,"*");
        }
        else{
            waitingMessages.push(message);
        }
    }

    var on = function (event, callback) {
        if (!events[event]) {
            events[event] = [];
        }
        events[event].push(callback);
        relayMessage({type:"FROM_WEBSITE", action: event, message:{messageType:"SUBSCRIBER"}});
    }

    var send = function (){

        var action = arguments[0];
        if(arguments.length == 2){
            if(typeof arguments[1] === "function"){
                relayMessage({type:"FROM_WEBSITE",action: action});

            }
        }
        else{
            relayMessage({type:"FROM_WEBSITE",action: action, message: arguments[1]});
        }

        if (!callbacks[action]) {
            callbacks[action] = [];
        }
        callbacks[action].push(arguments[arguments.length-1]);
    }


    window.addEventListener("messageFromExtension", function(event){

        while (callbacks[event.detail.action].length > 0) {
            var messageCallback = callbacks[event.detail.action].pop();
            messageCallback(event.detail.message);
        }
    });


    window.addEventListener("relayIsReady", function(event){
        relayIsReady = true;
        while(waitingMessages.length>0){
            var message = waitingMessages.pop();
            relayMessage(message);
        }
    });


    return {
        send: send,
        on: on,
        extensionIsActive:function(){
            return relayIsReady;
        }
    }
});
