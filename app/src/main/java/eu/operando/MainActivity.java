package eu.operando;


import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;

import org.greenrobot.eventbus.Subscribe;

import eu.operando.activity.AbstractLeftMenuActivity;
import eu.operando.activity.BaseActivity;
import eu.operando.events.EventLoginPage;
import eu.operando.events.EventSignIn;
import eu.operando.fragment.CreateAccountFragment;
import eu.operando.fragment.FirstScreenFragment;
import eu.operando.fragment.LoginFragment;
import eu.operando.osdk.swarm.client.events.SwarmLogoutEvent;
import eu.operando.osdk.swarm.client.utils.EventProvider;
import eu.operando.osdk.swarm.client.utils.SwarmConstants;
import eu.operando.osdk.swarm.client.events.SwarmLoginEvent;
import eu.operando.util.Constants;

import eu.operando.osdk.swarm.client.SwarmClient;

@SuppressWarnings("ALL")
public class MainActivity extends AbstractLeftMenuActivity {


    public FrameLayout mContainer;
    public RelativeLayout aboutRL;
    public DrawerLayout mDrawerLayout;
    private SwarmClient swarmClient;

    FirstScreenFragment firstScreenFragment;
    LoginFragment loginFragment;
    CreateAccountFragment createAccountFragment;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initUI();
        doOnInit();

    }

    private void initUI() {

        firstScreenFragment = new FirstScreenFragment();
        loginFragment = new LoginFragment();
        createAccountFragment = new CreateAccountFragment();
        mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);

        addFragment(R.id.main_fragment_container, firstScreenFragment, FirstScreenFragment.FRAGMENT_TAG);
        aboutRL = (RelativeLayout) findViewById(R.id.aboutRL);

        ActionBarDrawerToggle drawerToggle = new ActionBarDrawerToggle(this, mDrawerLayout, R.string.app_name,
                R.string.app_name);
        this.mDrawerLayout.setDrawerListener(drawerToggle);
        setComponents(drawerToggle, mDrawerLayout, INVOICES);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {

        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        int id = item.getItemId();

        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void doOnInit() {
        EventProvider eventProvider = EventProvider.getInstance();
        swarmClient = SwarmClient.getInstance(SwarmConstants.SWARMS_CONNECTION, "chromeBrowserExtension");
        //login
        String[] commandArguments = {"rafa", "swarm"};
        swarmClient.startSwarm("login.js","start", "userLogin", commandArguments);
    }

    @Subscribe
    public void onEvent (EventLoginPage event ){

       switch (event.action) {
           case Constants.events.LOGIN : {
               showLoginPage () ;
                break;
           }
           case Constants.events.CREATE_ACCOUNT:{
               showRegisterPage();
               break;
           }
        }
    }
    @Subscribe
    public void onEvent (EventSignIn event ) {
        showFirstFragment ();
    }

    @Subscribe
    public void onSwarmEvent (SwarmLoginEvent loginEvent ){
        System.out.println("TODO with login event");
        String sessionId = "";
        try {
            sessionId = loginEvent.getData().getJSONObject("meta").getString("sessionId");
            System.out.println(loginEvent.getData().get("sessionId"));
        } catch (JSONException e) {
            e.printStackTrace();
        }

        swarmClient.startSwarm("login.js","start", "logout");
    }

    @Subscribe
    public void onSwarmEvent (SwarmLogoutEvent logoutEvent ){
        //doOnInit();
    }



    private void showLoginPage (){
        replaceFragment(R.id.main_fragment_container, loginFragment, LoginFragment.FRAGMENT_TAG, "st1");
    }
    private void showRegisterPage (){
        replaceFragment(R.id.main_fragment_container,createAccountFragment, CreateAccountFragment.FRAGMENT_TAG,"st2");
    }
    private void showFirstFragment (){
        replaceFragment(R.id.main_fragment_container,firstScreenFragment, FirstScreenFragment.FRAGMENT_TAG,"st1");
    }
}
