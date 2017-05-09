


var privacySettings = [];
var port = chrome.runtime.connect({name: "applyTwitterSettings"});
port.postMessage({action: "waitingTwitterCommand", data: {status:"waitingTwitterCommand"}});

port.onMessage.addListener(function (msg) {
    if (msg.command == "applySettings") {
        privacySettings = msg.settings;
        secureAccount(function () {
            port.postMessage({action: "waitingTwitterCommand", data:{status:"settings_applied"}});
        });
    }
});

function secureAccount(callback){
    console.log(privacySettings);

    var SafetyForm = {
        "_method": "PUT",
        "authenticity_token": getAuthenticityToken(),
        "user[protected]": 0,
        "user[geo_enabled]": 0,
        "user[allow_media_tagging]": "none",
        "user[discoverable_by_email]": 0,
        "user[discoverable_by_mobile_phone]": 0,
        "user[allow_contributor_request]": "none",
        "user[allow_dms_from_anyone]": 0,
        "user[allow_dm_receipts]": 0,
        "user[nsfw_view]": 0,
        "user[nsfw_user]": 0
    };

$(document).ready(function(){

    setTimeout(function(){
        $("#settings_save").removeAttr("disabled");
        $("#settings_save").click();
        port.postMessage({action: "waitingTwitterCommand", data:{status:"giveMeCredentials"}});
    },100);


    $("#save_password").on("click",function(event){
        event.stopPropagation();

        SafetyForm["auth_password"] = $("#auth_password").val();

        $.ajax({
            type: "POST",
            url: "https://twitter.com/settings/safety/update",
            data: SafetyForm,
            success: function(data){
                console.log(data);

            },
            dataType: "html"
        });

    });
});







    port.postMessage({action: "waitingTwitterCommand", data:{status:"progress", progress:(0)}});

   // callback();
}



function getAuthenticityToken(){
    return $("#authenticity_token").val();
}
