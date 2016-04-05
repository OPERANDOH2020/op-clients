package eu.operando.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import eu.operando.BuildConfig;
import eu.operando.R;

/**
 * Created by raluca on 05.04.2016.
 */
public class LoginFragment extends Fragment {
    public static final String FRAGMENT_TAG =
            BuildConfig.APPLICATION_ID + ".LoginFragment";

    @Override
    public View onCreateView(LayoutInflater inflator, ViewGroup container, Bundle saveInstanceState)

    {
        View v = inflator.inflate(R.layout.fragment_login, container, false);
        return v;
    }
}
