package eu.operando.swarmclient.models;

import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.json.JSONObject;

/**
 * Created by Edy on 11/3/2016.
 */

public abstract class SwarmCallback<T extends Swarm> {
    private String resultEvent;
    private Class<? extends T> type;

    public SwarmCallback(String resultCtor,Class<? extends T> resultType) {
        this.resultEvent = resultCtor;
        this.type = resultType;
    }

    public String getResultEvent() {
        return resultEvent;
    }

    public abstract void call(T result);

    public void result(JSONObject result) {
        Log.e("Swarms: ", "result: " + result.toString() );
        T t = new Gson().fromJson(result.toString(),type);
        call(t);
    }
}
