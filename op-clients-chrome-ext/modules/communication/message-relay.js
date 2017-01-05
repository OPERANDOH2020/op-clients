var port = chrome.runtime.connect({name:"PLUSPRIVACY_WEBSITE"});

port.onMessage.addListener(function (data) {
    var event = new CustomEvent("messageFromExtension",	{
        detail: {
            message: data.message,
            action: data.action
        },
        bubbles: true,
        cancelable: true
    });
    document.dispatchEvent(event);
});

window.addEventListener("message", function(event) {
    // We only accept messages from ourselves
    if (event.source != window)
        return;

    if (event.data.type && (event.data.type == "FROM_WEBSITE")) {
        port.postMessage(event.data);
    }
}, false);



(function(){
    var event = new CustomEvent("relayIsReady",	{
        bubbles: true,
        cancelable: true
    });
    document.dispatchEvent(event);
})();