package eu.operando.swarmclient;

import android.util.Log;

import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.URISyntaxException;
import java.util.HashMap;

import eu.operando.swarmclient.models.Swarm;
import eu.operando.swarmclient.models.SwarmCallback;
import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;

/**
 * Created by Edy on 11/2/2016.
 */

public class SwarmClient {
    private static SwarmClient instance;
    private String connectionURL;

    private Socket ioSocket;
    private Gson gson;
    private HashMap<String, SwarmCallback> listeners;

    private SwarmClient(String connectionURL) {
        this.connectionURL = connectionURL;
        listeners = new HashMap<>();
        try {

            ioSocket = IO.socket(connectionURL);
            ioSocket.connect();

            Emitter.Listener onNewMessage = new Emitter.Listener() {
                @Override
                public void call(final Object... args) {
                    JSONObject data = (JSONObject) args[0];
                    Log.w("Swarms: ", "received: " + data);
                    Swarm swarm = gson.fromJson(data.toString(), Swarm.class);
                    if (listeners.containsKey(swarm.getMeta().getCtor())) {
                        listeners.get(swarm.getMeta().getCtor()).result(data);
                    }
                }
            };

            this.ioSocket.on("message", onNewMessage);
        } catch (URISyntaxException exception) {
            exception.printStackTrace();
        }
        gson = new Gson();
    }

    public static void init(String connectionURL) {
        instance = new SwarmClient(connectionURL);
    }

    public static SwarmClient getInstance() {
        if (instance == null) throw new IllegalStateException("init() was not called.");

        return instance;
    }

    public void startSwarm(Swarm swarm, SwarmCallback callback) {
        if (callback != null){
            listeners.put(callback.getResultEvent(), callback);
        }
        try {
            ioSocket.emit("message", new JSONObject(gson.toJson(swarm)));
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    public void restartSocket() {
        instance.ioSocket.disconnect();
        instance= new SwarmClient(connectionURL);
    }
}
