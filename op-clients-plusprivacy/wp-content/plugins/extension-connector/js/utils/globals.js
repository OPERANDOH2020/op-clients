/**
 * timeSince function code is from here http://stackoverflow.com/questions/3177836/how-to-format-time-since-xxx-e-g-4-minutes-ago-similar-to-stack-exchange-site
 * @param date
 * @returns {string}
 */

function timeSince(date) {
    var seconds = Math.floor((new Date() - date) / 1000);

    var interval = Math.floor(seconds / 31536000);

    if (interval > 1) {
        return interval + " years";
    }
    interval = Math.floor(seconds / 2592000);
    if (interval > 1) {
        return interval + " months";
    }
    interval = Math.floor(seconds / 86400);
    if (interval > 1) {
        return interval + " days";
    }
    interval = Math.floor(seconds / 3600);
    if (interval > 1) {
        return interval + " hours";
    }
    interval = Math.floor(seconds / 60);
    if (interval > 1) {
        return interval + " minutes";
    }
    return Math.floor(seconds) + " seconds";
}

function convertImageToBase64(file, successCallback, errorCallback) {
    var _URL = window.URL || window.webkitURL;

    if (file) {
        if (file.size > 131072) {//128 kb
            errorCallback("imageSizeLimitExceeded");
        }
        else {
            var image = new Image();
            image.onload = function () {
                if (this.width === this.height && this.width <= 256) {
                    var reader = new FileReader();
                    reader.onload = function (readerEvt) {
                        var binaryString = readerEvt.target.result;
                        var base64String = btoa(binaryString);
                        successCallback(base64String);
                    };

                    reader.readAsBinaryString(file);
                }
                else {
                    errorCallback("invalidImageMeasures");
                }
            };

            image.src = _URL.createObjectURL(file);
        }
    }
}

function JSON2CSV(header,objArray) {
    var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;

    var str = '';
    var line = '';

        for (var index in header) {
            var value = header[index] + "";
            line +=  value.replace(/"/g, '""') + ',';
        }

        line = line.slice(0, -1);
        str += line + '\r\n';

    for (var i = 0; i < array.length; i++) {
        var line = '';

        /*if ($("#quote").is(':checked')) {
            for (var index in array[i]) {
                var value = array[i][index] + "";
                line += '"' + value.replace(/"/g, '""') + '",';
            }
        } else {
            for (var index in array[i]) {
                line += array[i][index] + ',';
            }
        }*/


        for (var index in array[i]) {
            line += array[i][index] + ',';
        }

        line = line.slice(0, -1);
        str += line + '\r\n';
    }
    return str;

}

var ORGANISATIONS = {
    public: "Public",
    osp: "OSP",
    psp: "PSP"
};
