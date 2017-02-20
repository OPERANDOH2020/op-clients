<?php
/**
 * Plugin Name: PlusPrivacy Connector
 * Plugin URI: http://plusprivacy.com
 * Description: Communication between extension and website.
 * Version: 1.0.0
 * Author: Rafael Mastaleru
 * License: MIT
 */

add_action("plusprivacy_head", insertPlusPrivacyHeader);

function insertPlusPrivacyHeader(){
    echo file_get_contents(plugins_url('/html/header/navbar.html', __FILE__));
    wp_enqueue_style('app-navigation', plugins_url('/css/navigation.css', __FILE__));
}

add_shortcode('confirm-account', 'confirm_user_account');
add_shortcode('account-login', 'account_login');
add_shortcode('account-register', 'register_account');
add_shortcode('osp-register', 'osp_register_account');
add_shortcode('osp-dashboard-offers', 'osp_dashboard_offers');
add_shortcode('osp-dashboard-deals', 'osp_dashboard_deals');
add_shortcode('osp-dashboard-account', 'osp_dashboard_account');
add_shortcode('osp-requests', 'osp_requests');
add_shortcode('osp-list', 'osp_list');


add_action('wp_enqueue_scripts', 'load_swarm_resources');
add_action('wp_enqueue_scripts', 'confirmUserController');
add_action('wp_enqueue_scripts', 'loginController');
add_action('wp_enqueue_scripts', 'signupController');
add_action('wp_enqueue_scripts', 'ospSignupController');
add_action('wp_enqueue_scripts', 'ospOffersController');
add_action('wp_enqueue_scripts', 'ospDealsController');
add_action('wp_enqueue_scripts', 'ospAccountController');
add_action('wp_enqueue_scripts', 'ospRequestsController');
add_action('wp_enqueue_scripts', 'ospListController');

function load_swarm_resources()
{
    wp_enqueue_script('js-cookie', plugins_url('/js/utils/js.cookie.js', __FILE__));
    wp_enqueue_script('globals', plugins_url('/js/utils/globals.js', __FILE__));
    wp_enqueue_script('bootstrap-min', plugins_url('/js/utils/bootstrap/bootstrap.min.js', __FILE__));
    wp_enqueue_script('socket-io', plugins_url('/js/swarm-services/socket.io-1.0.6.js', __FILE__));
    wp_enqueue_script('swarm-debug', plugins_url('/js/swarm-services/SwarmDebug.js', __FILE__));
    wp_enqueue_script('swarm-client', plugins_url('/js/swarm-services/SwarmClient.js', __FILE__));
    wp_enqueue_script('swarm-hub', plugins_url('/js/swarm-services/SwarmHub.js', __FILE__));
    wp_enqueue_script('angular', plugins_url('/js/angular/angular.min.js', __FILE__));
    wp_enqueue_script('modal-service', plugins_url('/js/utils/angular-modal/angular-modal-service.js', __FILE__));
    wp_enqueue_script('notification-service', plugins_url('/js/utils/angular-ui-notification/angular-ui-notification.min.js', __FILE__));
    wp_enqueue_style('notification-service-style', plugins_url('/js/utils/angular-ui-notification/angular-ui-notification.min.css', __FILE__));
    wp_enqueue_script('shared-service', plugins_url('/js/app/modules/sharedService.js', __FILE__));
    wp_enqueue_script('menu-angular-app', plugins_url('/js/app/menuApp.js', __FILE__));
    //wp_enqueue_script('menu-locator-service', plugins_url('/js/app/services/menuLocatorService.js', __FILE__));
    wp_enqueue_script('menu-controller', plugins_url('/js/app/controllers/menuController.js', __FILE__));

    wp_enqueue_script('angular-app', plugins_url('/js/app/app.js', __FILE__));
    wp_enqueue_script('angular-service-connection', plugins_url('/js/app/services/connectionService.js', __FILE__));
    wp_enqueue_script('angular-messenger-service', plugins_url('/js/app/services/messengerService.js', __FILE__));
    wp_enqueue_script('angular-swarm-service', plugins_url('/js/app/services/swarm-service.js', __FILE__));
    wp_enqueue_script('loader', plugins_url('/js/app/directives/loader.js', __FILE__));
    wp_enqueue_style('bootstrap', plugins_url('/css/bootstrap/bootstrap.css', __FILE__));
    wp_enqueue_style('bootstrap-theme', plugins_url('/css/bootstrap/bootstrap-theme.min.css', __FILE__));
    wp_enqueue_style('bootstrap-vertical-tabs', plugins_url('/css/bootstrap/bootstrap.vertical-tabs.min.css', __FILE__));
    wp_enqueue_style('plusprivacy-bootstrap', plugins_url('/css/bootstrap/plusprivacy-theme.css', __FILE__));
    wp_enqueue_style('app-style', plugins_url('/css/app.css', __FILE__));

}

function confirm_user_account()
{
    if (isset ($_GET['confirmation_code']) && $_GET['confirmation_code']) {
        echo file_get_contents(plugins_url('/html/confirm_user_tpl.html', __FILE__));
    }
}

/************************************************
 *************** Add file contents ***************
 ************************************************/

function account_login()
{
    echo file_get_contents(plugins_url('/html/user_login.html', __FILE__));
}

function register_account()
{
    echo file_get_contents(plugins_url('/html/user_signup.html', __FILE__));
}

function osp_register_account()
{
    echo file_get_contents(plugins_url('/html/osp/register_osp.html', __FILE__));
}

function osp_dashboard_offers()
{
    echo file_get_contents(plugins_url('/html/osp/dashboard/offers.html', __FILE__));
}

function osp_dashboard_deals()
{
    echo file_get_contents(plugins_url('/html/osp/dashboard/deals.html', __FILE__));
}

function osp_dashboard_account()
{
    echo file_get_contents(plugins_url('/html/osp/dashboard/account.html', __FILE__));
}

function osp_requests()
{
    echo file_get_contents(plugins_url('/html/admin/osp_requests.html', __FILE__));
}

function osp_list()
{
    echo file_get_contents(plugins_url('/html/admin/osp_list.html', __FILE__));
}


/************************************************
 *************** Insert JS app files *************
 ************************************************/

function confirmUserController()
{
    insertScriptIfShortcode("confirmUserController", 'confirm-account', plugins_url('/js/app/controllers/confirmUserController.js', __FILE__));
}

function loginController()
{
    insertScriptIfShortcode("loginController", 'account-login', plugins_url('/js/app/controllers/loginController.js', __FILE__));
}

function signupController()
{
    insertScriptIfShortcode("signupController", 'account-register', plugins_url('/js/app/controllers/signupController.js', __FILE__));
}

function ospSignupController()
{
    insertScriptIfShortcode("ospSignupController", 'osp-register', plugins_url('/js/app/controllers/osp/ospSignupController.js', __FILE__));
}

function ospOffersController()
{   insertScriptIfShortcode("angular-material-js", 'osp-dashboard-offers', plugins_url('/js/utils/angular-material/angular-material.min.js', __FILE__));
    insertStyleIfShortcode("angular-material-style", 'osp-dashboard-offers', plugins_url('/js/utils/angular-material/angular-material.css', __FILE__));
    insertScriptIfShortcode("moment.js", 'osp-dashboard-offers', plugins_url('/js/utils/momentjs/moment.js', __FILE__));
    insertScriptIfShortcode("angular-animate.js", 'osp-dashboard-offers', plugins_url('/js/utils/angular-animate/angular-animate.js', __FILE__));
    insertScriptIfShortcode("angular-aria.js", 'osp-dashboard-offers', plugins_url('/js/utils/angular-aria/angular-aria.min.js', __FILE__));
    insertScriptIfShortcode("angular-messages.js", 'osp-dashboard-offers', plugins_url('/js/utils/angular-messages/angular-messages.min.js', __FILE__));
    insertScriptIfShortcode("mdPickers.js", 'osp-dashboard-offers', plugins_url('/js/utils/mdPickers/mdPickers.min.js', __FILE__));
    insertStyleIfShortcode("mdPickers.css", 'osp-dashboard-offers', plugins_url('/js/utils/mdPickers/mdPickers.min.css', __FILE__));

    insertScriptIfShortcode("angular-datatables.min.js", 'osp-dashboard-offers', plugins_url('/js/utils/angular-datatables/angular-datatables.min.js', __FILE__));
    insertScriptIfShortcode("angular-datatables.bootstrap.min", 'osp-dashboard-offers', plugins_url('/js/utils/angular-datatables/angular-datatables.bootstrap.min.js', __FILE__));
    insertScriptIfShortcode("jquery.dataTables.min", 'osp-dashboard-offers', plugins_url('/js/utils/angular-datatables/jquery.dataTables.min.js', __FILE__));
    insertStyleIfShortcode("datatables.bootstrap", 'osp-dashboard-offers', plugins_url('/js/utils/angular-datatables/datatables.bootstrap.min.css', __FILE__));

    insertScriptIfShortcode("datePicker-directive", 'osp-dashboard-offers', plugins_url('/js/app/directives/datePicker.js', __FILE__));
    insertScriptIfShortcode("ospOffersController", 'osp-dashboard-offers', plugins_url('/js/app/controllers/osp/ospOffersController.js', __FILE__));
}

function ospDealsController()
{
    insertScriptIfShortcode("ospDealsController", 'osp-dashboard-deals', plugins_url('/js/app/controllers/osp/ospDealsController.js', __FILE__));
}

function ospAccountController()
{
    insertScriptIfShortcode("ospAccountController", 'osp-dashboard-account', plugins_url('/js/app/controllers/osp/ospAccountController.js', __FILE__));
}

function ospRequestsController()
{
    insertScriptIfShortcode("angular-datatables.min.js", 'osp-requests', plugins_url('/js/utils/angular-datatables/angular-datatables.min.js', __FILE__));
    insertScriptIfShortcode("angular-datatables.bootstrap.min", 'osp-requests', plugins_url('/js/utils/angular-datatables/angular-datatables.bootstrap.min.js', __FILE__));
    insertScriptIfShortcode("jquery.dataTables.min", 'osp-requests', plugins_url('/js/utils/angular-datatables/jquery.dataTables.min.js', __FILE__));
    insertStyleIfShortcode("datatables.bootstrap", 'osp-requests', plugins_url('/js/utils/angular-datatables/datatables.bootstrap.min.css', __FILE__));
    insertScriptIfShortcode("ospRequestsController", 'osp-requests', plugins_url('/js/app/controllers/admin/ospRequestsController.js', __FILE__));
}

function ospListController()
{
    insertScriptIfShortcode("angular-datatables.min.js", 'osp-list', plugins_url('/js/utils/angular-datatables/angular-datatables.min.js', __FILE__));
    insertScriptIfShortcode("angular-datatables.bootstrap.min", 'osp-list', plugins_url('/js/utils/angular-datatables/angular-datatables.bootstrap.min.js', __FILE__));
    insertScriptIfShortcode("jquery.dataTables.min", 'osp-list', plugins_url('/js/utils/angular-datatables/jquery.dataTables.min.js', __FILE__));
    insertStyleIfShortcode("datatables.bootstrap", 'osp-list', plugins_url('/js/utils/angular-datatables/datatables.bootstrap.min.css', __FILE__));
    insertScriptIfShortcode("ospListController", 'osp-list', plugins_url('/js/app/controllers/admin/ospListController.js', __FILE__));
}

function insertScriptIfShortcode($script_name, $shortcode, $script)
{
    global $post;
    if (is_a($post, 'WP_Post') && has_shortcode($post->post_content, $shortcode)) {
        wp_enqueue_script($script_name, $script);
    }
}

function insertStyleIfShortcode($style_name, $shortcode, $style)
{
    global $post;
    if (is_a($post, 'WP_Post') && has_shortcode($post->post_content, $shortcode)) {
        wp_enqueue_style($style_name, $style);
    }
}

?>