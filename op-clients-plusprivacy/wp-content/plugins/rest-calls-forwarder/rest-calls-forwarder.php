<?php
/**
 * Plugin Name: Rest Calls Forwarder
 * Plugin URI: http://plusprivacy.com
 * Description: This plugin get the url parameters and make a certain REST call
 * Version: 1.0.0
 * Author: Rafael Mastaleru
 * License: MIT
 */

add_shortcode('confirm-account', 'confirm_user_account');


if($_GET['confirmation_code']){
    add_action( 'wp_enqueue_scripts', 'swarm_clients_resources' );
}


function confirm_user_account(){

    if(isset ($_GET['confirmation_code']) && $_GET['confirmation_code']){
        echo file_get_contents(plugins_url( '/html/confirm_user_tpl.html', __FILE__ ));
    }
}


function swarm_clients_resources() {
    wp_enqueue_script( 'socket-io', plugins_url( '/js/swarm-services/socket.io-1.0.6.js', __FILE__ ));
    wp_enqueue_script( 'swarm-debug', plugins_url( '/js/swarm-services/SwarmDebug.js', __FILE__ ));
    wp_enqueue_script( 'swarm-client', plugins_url( '/js/swarm-services/SwarmClient.js', __FILE__ ));
    wp_enqueue_script( 'swarm-hub', plugins_url( '/js/swarm-services/SwarmHub.js', __FILE__ ));
    wp_enqueue_script( 'angular', plugins_url( '/js/angular/angular.min.js', __FILE__ ));
    wp_enqueue_script( 'angular-app', plugins_url( '/js/app/app.js', __FILE__ ));
    wp_enqueue_script( 'angular-service-connection', plugins_url( '/js/app/services/connectionService.js', __FILE__ ));
    wp_enqueue_script( 'angular-swarm-service', plugins_url( '/js/app/services/swarm-service.js', __FILE__ ));
    wp_enqueue_script( 'angular-service-user', plugins_url( '/js/app/controllers/confirmUserController.js', __FILE__ ));
}

?>