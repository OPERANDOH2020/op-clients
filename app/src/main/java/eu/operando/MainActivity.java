package eu.operando;


import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;

import org.greenrobot.eventbus.Subscribe;

import eu.operando.activity.BaseActivity;
import eu.operando.events.EventLoginPage;
import eu.operando.fragment.FirstScreenFragment;
import eu.operando.fragment.LoginFragment;
import eu.operando.util.Constants;

@SuppressWarnings("ALL")
public class MainActivity extends BaseActivity {


    public FrameLayout mContainer;
    public RelativeLayout aboutRL;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initUI();

    }

    private void initUI() {

        addFragment(R.id.main_fragment_container, new FirstScreenFragment(), FirstScreenFragment.FRAGMENT_TAG);
        aboutRL = (RelativeLayout) findViewById(R.id.aboutRL);
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
               break;
           }
        }
    }

    private void showLoginPage (){
        addFragment(R.id.main_fragment_container,new LoginFragment(), LoginFragment.FRAGMENT_TAG);
    }
}
