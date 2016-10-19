package eu.operando.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ListView;
import android.widget.TextView;


import org.greenrobot.eventbus.Subscribe;

import eu.operando.R;
import eu.operando.adapter.IdentitiesListAdapter;
import eu.operando.osdk.swarm.client.SwarmClient;
import eu.operando.osdk.swarm.client.events.SwarmIdentityListEvent;

/**
 * Created by Edy on 10/19/2016.
 */
public class IdentitiesActivity extends BaseActivity{
    ListView identitiesLV;
    View addIdentityBtn;
    public static void start(Context context) {
        Intent starter = new Intent(context, IdentitiesActivity.class);
        context.startActivity(starter);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        try {
            SwarmClient.getInstance().startSwarm("identity.js","start","getMyIdentities");
        } catch (Exception e) {
            e.printStackTrace();
        }
        setContentView(R.layout.activity_identities);
        identitiesLV = ((ListView) findViewById(R.id.identitiesLV));
        addIdentityBtn = findViewById(R.id.addIdentityBtn);
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Subscribe
    public void onIdentitiesListEvent(SwarmIdentityListEvent event){
        if(event.getIdentities().size() > 0 ){
            ((TextView) findViewById(R.id.realIdentityTV)).setText(event.getIdentities().get(0).getUserId());
        }
        identitiesLV.setAdapter(new IdentitiesListAdapter(this,event.getIdentities()));
    }
}
