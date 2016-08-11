window.readSettings = function (settingJsonString)
{
    var jQeryURL = "https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"
    
    if (!window.jQuery)
    {
        var jq = document.createElement('script'); jq.type = 'text/javascript';
        // Path to jquery.js file, eg. Google hosted version
        jq.src = jQeryURL;
        
        document.getElementsByTagName('head')[0].appendChild(jq);
    }
    
    var jquery_selector = JSON.parse(settingJsonString);
    
    if (typeof jQuery == 'undefined') {
        return "jQuery is not loaded!";
    } else {
        return "jQuery is loaded!";
    }
    
    return JSON.stringify(jquery_selector);
    
    switch (jquery_selector.valueType){
        case "attrValue": setting = jQuery(jquery_selector.element).attr(jquery_selector.attrValue); break;
        case "checkbox": setting = jQuery(jquery_selector.element).attr("checked")?true:false; break;
        case "inner": setting = jQuery(jquery_selector.element).text(); break;
        case "classname": setting = jQuery(jquery_selector.element).hasClass(jquery_selector.attrValue); break;
        case "radio" :setting = jQuery(jquery_selector.element + ":checked").attr("value"); break;
        case "selected": setting = jQuery(jquery_selector.element).attr("value"); break;
        case "length": setting = jQuery(jquery_selector.element).length?jQuery(jquery_selector.element).length:0; break;
        default: setting = null;
    }

    return JSON.stringify({settingKey:setting.settingKey, setting:setting});
}