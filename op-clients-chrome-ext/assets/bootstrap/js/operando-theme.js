$(document).ready(function () {

    /**
     *Custom scrollbar
     */
    (function ($) {
        $(window).on("load", function () {
            $("#wrapper").mCustomScrollbar({
                scrollButtons: {enable: true},
                theme: "light-thick",
                scrollbarPosition: "outside",
                callbacks: {
                    whileScrolling: function () {
                        if (this.mcs.top < -100) {
                            $('#return-to-top').fadeIn();
                        }
                        else {
                            $('#return-to-top').fadeOut();
                        }
                    }
                }

            });
        });
    })(jQuery);

    /**
     *Scroll Up Button
     */
    (function ($) {
        $('#return-to-top').click(function () {
            $("#wrapper").mCustomScrollbar("scrollTo", "top", {
                scrollEasing: "easeOut"
            });

        });
    })(jQuery);

})

