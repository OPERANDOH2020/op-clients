package eu.operando.activity;

import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Toast;

import com.special.ResideMenu.ResideMenu;
import com.special.ResideMenu.ResideMenuItem;

import eu.operando.R;

public class MainActivity extends AppCompatActivity {

    public static void start(Context context) {
        Intent starter = new Intent(context, MainActivity.class);
        context.startActivity(starter);
    }

    private ResideMenu resideMenu;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initUI();
    }

    private void initUI() {
        initMenu();
    }

    private void initMenu() {
        resideMenu = new ResideMenu(this);
        resideMenu.setBackground(R.drawable.bg);
        resideMenu.attachToActivity(this);
        resideMenu.setScaleValue(0.9f);
        resideMenu.setUse3D(true);

        View.OnClickListener menuClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int index = (int) v.getTag();
                onDrawerItemClicked(index);
            }
        };


        String[] titles = new String[] {"Dashboard",
                "Identities Management",
                "Privacy for Benefits",
                "Private Browsing",
                "Application Scanner",
                "Notifications"};
        int[] icons = new int[] {R.drawable.ic_home,
                R.drawable.ic_identities,
                R.drawable.ic_deals,
                R.drawable.ic_private_browsing,
                R.drawable.ic_scan,
                R.drawable.ic_notifications};

        for (int i = 0; i < titles.length; i++) {
            ResideMenuItem item = new ResideMenuItem(this,icons[i],titles[i]);
            item.setOnClickListener(menuClickListener);
            item.setTag(i);
            resideMenu.addMenuItem(item,ResideMenu.DIRECTION_LEFT);
        }

        findViewById(R.id.ic_menu).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                resideMenu.openMenu(ResideMenu.DIRECTION_LEFT);
            }
        });

        findViewById(R.id.ic_profile).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                resideMenu.openMenu(ResideMenu.DIRECTION_RIGHT);
            }
        });
    }

    private void onDrawerItemClicked(int index) {
        Toast.makeText(this, index+"", Toast.LENGTH_SHORT).show();
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        return resideMenu.dispatchTouchEvent(ev);
    }
}
