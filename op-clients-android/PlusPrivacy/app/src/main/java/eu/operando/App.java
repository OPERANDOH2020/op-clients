package eu.operando;

import android.app.Application;

import io.paperdb.Paper;

/**
 * Created by Edy on 11/25/2016.
 */

public class App extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        Paper.init(this);
    }
}
