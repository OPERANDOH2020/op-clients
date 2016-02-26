angular.module('optionsApp', ['components','angularModalService'])
.config( [
    '$compileProvider',
    function( $compileProvider )
    {   //to accept chrome protocol
        $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome|chrome-extension):/);
        $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome|chrome-extension):/);

    }
]);
