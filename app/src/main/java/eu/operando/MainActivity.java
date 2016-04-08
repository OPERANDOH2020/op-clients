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
import eu.operando.util.Constants;

@SuppressWarnings("ALL")
public class MainActivity extends AbstractLeftMenuActivity {


    public FrameLayout mContainer;
    public RelativeLayout aboutRL;
    public DrawerLayout mDrawerLayout;

    FirstScreenFragment firstScreenFragment;
    LoginFragment loginFragment;
    CreateAccountFragment createAccountFragment;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initUI();

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
