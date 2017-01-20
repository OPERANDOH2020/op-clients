var port = chrome.runtime.connect({name:"EVENT-DISPATCHER"});

port.postMessage({action:"onHighlighted"});

port.onMessage.addListener(function (data) {

console.log(data);

});
