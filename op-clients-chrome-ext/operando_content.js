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

    (function () {

        var loginIsVisible = false;
        var popupIsDismissed = false;

        var visibilityWatcher = function () {

            jQuery(".badge-facebook-connect, .btn-facebook, a.auth-twitter").each(function (i, element) {

                if (element.outerHTML.indexOf("login-form") > 0 || element.outerHTML.indexOf("loginFB") > 0 || element.className.indexOf("auth-twitter")>-1) {
                    var self = this;

                    if ((jQuery(self).visible()) == true) {
                        loginIsVisible = true;
                        if(popupIsDismissed == false){
                            createPfBPopup(self);
                            clearInterval(visibilityWatcherInterval);
                        }

                    } else{
                        loginIsVisible = false;
                        popupIsDismissed = false;
                    }
                }

            });

        }

        var visibilityWatcherInterval = setInterval(function () {
                visibilityWatcher();
            }, 300
        );


        function createPfBPopup(element){
            chrome.runtime.sendMessage({message:"fileNeeded", file: "jquery.webui-popover.min.css", type:"css"});


           /* var elementWrapper = jQuery(element).parent()[0];

            var elementOffset = jQuery(element).offset();
            var elementWidth = jQuery(element).width();
            var elementHeight = jQuery(element).height();

            var offsetLeft = elementOffset.left + elementWidth;
            var offsetTop = elementOffset.top + elementHeight;*/


            var settings = {
                trigger:'sticky',
                title:'Privacy for Benefits ',
                content:'<div><p>This is webui popover demo.</p><p>just enjoy it and have fun !</p>'
                    +'<button>Accept</button>'
                    +'<button>Decline</button>'
                    +'</div>',
                multi: true,
                closeable:true,
                dismissible:true,
                delay:100,
                padding:true,
                backdrop:true,
                width:300,
                animation:'pop',
                placement:'right',


                onHide: function($element) {
                    popupIsDismissed = true;
                    visibilityWatcherInterval = setInterval(visibilityWatcher, 300);
                }
            };
            jQuery(element).webuiPopover('destroy').webuiPopover(settings);

        }

    })();





