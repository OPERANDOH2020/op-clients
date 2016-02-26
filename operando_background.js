var webRequest = chrome.webRequest;


var HEADERS_TO_STRIP_LOWERCASE = [
    'content-security-policy',
    'x-frame-options',
];

webRequest.onHeadersReceived.addListener(
    function (details) {
        return {
            responseHeaders: details.responseHeaders.filter(function (header) {
                return HEADERS_TO_STRIP_LOWERCASE.indexOf(header.name.toLowerCase()) < 0;
            })
        };
    }, {
        urls: ["<all_urls>"]
    }, ["blocking", "responseHeaders"]);


chrome.runtime.onMessage.addListener(function (message, sender, sendResponse) {

    if (message.message === "getCookies") {
        if (message.url) {
            chrome.cookies.getAll({url: message.url}, function (cookies) {
                sendResponse(cookies);
            });

            return true;
        }
    }


    if (message.message === "waitForAPost") {
        if (message.template) {

            webRequest.onBeforeRequest.addListener(function waitForPost(request) {
                    if (request.method == "POST") {
                        var requestBody = request.requestBody;
                        if (requestBody.formData) {
                            var formData = requestBody.formData;
                            for (var prop in message.template) {
                                if (formData[prop]) {
                                    if(formData[prop] instanceof Array){
                                        message.template[prop] = formData[prop][0];
                                    }
                                    else{
                                        message.template[prop] = formData[prop];
                                    }
                                }
                            }

                            webRequest.onBeforeRequest.removeListener(waitForPost);
                            sendResponse ({template:message.template});
                        }
                    }

                },
                {urls: ["<all_urls>"]},
                ["blocking", "requestBody"]);
        }
        return true;
    }

});

webRequest.onBeforeSendHeaders.addListener(function(details) {

        var referer = "";
        for (var i = 0; i < details.requestHeaders.length; ++i) {
            var header = details.requestHeaders[i];
            if (header.name === "X-Alt-Referer") {
                referer = header.value;
                details.requestHeaders.splice(i, 1);
                break;
            }
        }
        if (referer !== "") {
            for (var i = 0; i < details.requestHeaders.length; ++i) {
                var header = details.requestHeaders[i];
                if (header.name === "Referer") {
                    details.requestHeaders[i].value = referer;
                    break;
                }
            }
        }

        return {requestHeaders: details.requestHeaders};

    },
    {urls: ["<all_urls>"]},
    ["blocking", "requestHeaders"]);



chrome.tabs.onCreated.addListener(function(tab){
    insertJavascriptFile(tab.id,"operando/apps/pfb.js");
})


function insertJavascriptFile(id, file, callback){
        chrome.tabs.executeScript(id, {
        file: file
    }, function () {
        if (chrome.runtime.lastError) {
            console.error(chrome.runtime.lastError.message);
        }
        else {
            if (callback) {
                callback();
            }
        }
    });
}