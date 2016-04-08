package eu.operando.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import org.greenrobot.eventbus.Subscribe;

import eu.operando.R;
import eu.operando.events.EventLoginPage;
import eu.operando.events.EventSignIn;
import eu.operando.util.SharedPreferencesService;

/**
 * Created by raluca on 08.04.2016.
 */
public class DrawerFragment extends Fragment {

    TextView emailTV ;

    @Override
    public View onCreateView(LayoutInflater inflator, ViewGroup container, Bundle saveInstanceState)

    {
        View v = inflator.inflate(R.layout.fragment_navigation_drawer, container, false);
        initUI (v);
        return v;
    }

    private void initUI (View v){
        emailTV = (TextView) v.findViewById(R.id.emailTV);
    }

    @Subscribe
    public void onEvent (EventSignIn event ) {
        emailTV.setText(SharedPreferencesService.getInstance(getActivity()).getUserEmail());
    }

}
