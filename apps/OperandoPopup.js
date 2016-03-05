angular.module('op-popup',['operandoCore'])
    .config( [
        '$compileProvider',
        function( $compileProvider )
        {   //to accept chrome protocol
            $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome|chrome-extension|chrome-extension-resource):/);
            $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome|chrome-extension|chrome-extension-resource):/);

        }
    ]);
