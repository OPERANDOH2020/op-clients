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
                scrollInertia:300,
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

    /**menu black magic here**/


    $(".no-sub-menu a").on("click", function () {
        $('.collapse').collapse('hide');
        $('.opened').removeClass('opened');
    })

    $('a.panel-heading').click(function() {
        $(this).parents('.panel').toggleClass('opened');
    });

})

