package eu.operando.fragment;


import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import eu.operando.BuildConfig;
import eu.operando.R;
import eu.operando.activity.BaseActivity;

/**
 * Created by raluca on 05.04.2016.
 */
public class FirstScreenFragment extends Fragment {
    public static final String FRAGMENT_TAG =
            BuildConfig.APPLICATION_ID + ".MainFragment";

    @Override
    public View onCreateView(LayoutInflater inflator, ViewGroup container, Bundle saveInstanceState)

    {
        View v = inflator.inflate(R.layout.fragment_main, container, false);
        return v;
    }


}
