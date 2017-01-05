<?php
/**
 * Plugin Name: PlusPrivacy Connector
 * Plugin URI: http://plusprivacy.com
 * Description: Communication between extension and website.
 * Version: 1.0.0
 * Author: Rafael Mastaleru
 * License: MIT
 */

add_shortcode('confirm-account', 'confirm_user_account');
add_shortcode('account-login', 'account_login');
add_shortcode('account-register', 'register_account');


add_action( 'wp_enqueue_scripts', 'load_swarm_resources' );
add_action( 'wp_enqueue_scripts', 'confirmUserController' );
add_action( 'wp_enqueue_scripts', 'loginController' );
add_action( 'wp_enqueue_scripts', 'signupController' );

function load_swarm_resources(){
    wp_enqueue_script( 'socket-io', plugins_url( '/js/swarm-services/socket.io-1.0.6.js', __FILE__ ));
    wp_enqueue_script( 'swarm-debug', plugins_url( '/js/swarm-services/SwarmDebug.js', __FILE__ ));
    wp_enqueue_script( 'swarm-client', plugins_url( '/js/swarm-services/SwarmClient.js', __FILE__ ));
    wp_enqueue_script( 'swarm-hub', plugins_url( '/js/swarm-services/SwarmHub.js', __FILE__ ));
    wp_enqueue_script( 'angular', plugins_url( '/js/angular/angular.min.js', __FILE__ ));
    wp_enqueue_script( 'angular-app', plugins_url( '/js/app/app.js', __FILE__ ));
    wp_enqueue_script( 'angular-service-connection', plugins_url( '/js/app/services/connectionService.js', __FILE__ ));
    wp_enqueue_script( 'angular-messenger-service', plugins_url( '/js/app/services/messengerService.js', __FILE__ ));
    wp_enqueue_script( 'angular-swarm-service', plugins_url( '/js/app/services/swarm-service.js', __FILE__ ));
    wp_enqueue_script( 'loader', plugins_url( '/js/app/directives/loader.js', __FILE__ ));
    wp_enqueue_style( 'app-style', plugins_url( '/css/app.css', __FILE__ ) );
}


function confirm_user_account(){

    if(isset ($_GET['confirmation_code']) && $_GET['confirmation_code']){
        echo file_get_contents(plugins_url( '/html/confirm_user_tpl.html', __FILE__ ));
    }
}

function account_login(){
    echo file_get_contents(plugins_url( '/html/user_login.html', __FILE__ ));
}
function register_account(){
    echo file_get_contents(plugins_url( '/html/user_signup.html', __FILE__ ));
}


function confirmUserController() {
    insertScriptIfShortcode('confirm-account', plugins_url( '/js/app/controllers/confirmUserController.js', __FILE__ ));
}

function loginController(){
    insertScriptIfShortcode('account-login', plugins_url( '/js/app/controllers/loginController.js', __FILE__ ));
}

function signupController(){
    insertScriptIfShortcode('account-register', plugins_url( '/js/app/controllers/signupController.js', __FILE__ ));
}


function insertScriptIfShortcode($shortcode, $script){
    global $post;
    if( is_a( $post, 'WP_Post' ) && has_shortcode( $post->post_content, $shortcode) ) {
        wp_enqueue_script($shortcode, $script);
    }
}

?>