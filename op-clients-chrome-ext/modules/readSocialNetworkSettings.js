var port = chrome.runtime.connect({name: "getSNSettings"});
port.postMessage({status: "waitingCommand"});
port.onMessage.addListener(function (msg) {
    if (msg.command == "scan") {
        console.log("SCAN RECEIVED");

        var jquery_selector = msg.setting.jquery_selector;
        var setting = null;
        console.log(jquery_selector.valueType);

        switch (jquery_selector.valueType){
            case "attrValue": setting = jQuery(jquery_selector.element).attr(jquery_selector.attrValue); break;
            case "checkbox": setting = jQuery(jquery_selector.element).attr("checked")?true:false; break;
            case "inner": setting = jQuery(jquery_selector.element).text(); break;
            case "classname": setting = jQuery(jquery_selector.element).hasClass(jquery_selector.attrValue); break;
            case "radio" :setting = jQuery(jquery_selector.element + ":checked").attr("value"); break;
            case "selected": setting = jQuery(jquery_selector.element).attr("value"); break;
            default: setting = null;
        }
        console.log(setting);

        port.postMessage({status: "finishedCommand", settingKey:msg.setting.settingKey, settingValue:setting});
    }
});


