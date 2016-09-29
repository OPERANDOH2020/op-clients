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

            $('.panel-collapse').on('hide.bs.collapse', function(e){

                if ($(this).is(e.target)) {
                    $(this).closest(".panel").each(function(){
                        if($(this).find("li.active").length == 0){
                            $(this).removeClass('opened');
                        }

                    })
                }
            });

            $('.panel-collapse').on('show.bs.collapse', function(e){
                if ($(this).is(e.target)) {
                    $(this).closest(".panel").each(function () {
                        $(this).addClass('opened');
                    })
                }
            });

        });

    })(jQuery);

});

