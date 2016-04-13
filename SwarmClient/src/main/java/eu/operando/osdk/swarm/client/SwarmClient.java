package eu.operando.osdk.swarm.client;


import com.google.gson.Gson;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.URISyntaxException;

import io.socket.client.IO;
import io.socket.client.Socket;

public class SwarmClient {

    private Socket ioSocket;
    private SwarmHub swarmHub;
    private String tenantId;

    public SwarmClient(String connectionURL, String tenantId) {
        this.tenantId = tenantId;
        try {
            ioSocket = IO.socket(connectionURL);
            swarmHub = new SwarmHub(ioSocket);
            ioSocket.connect();

            //getIdentity();
        } catch (URISyntaxException exception) {
            //WHAT TODO:-??
        }
    }


    /*(public void swarmTask(SwarmCommand swarmCommand) {
        try {
            //don't ask
            JSONObject swarmData  = new JSONObject(swarmCommand.getJson().toString());
            this.ioSocket.emit("message", swarmData);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }*/




    public Socket getSocketInstance() {
        return this.ioSocket;
    }

    public void startSwarm(String swarmName, String phase, String ctor, String[]... data){

        JSONObject swarmMeta = new JSONObject();
        JSONObject swarmData = new JSONObject();
        Gson gsonData = new Gson();

        try {
            swarmMeta.put("swarmingName",swarmName);
            swarmMeta.put("phase", phase);
            swarmMeta.put("command","start");
            swarmMeta.put("ctor",ctor);
            swarmMeta.put("tenantId",this.tenantId);
            if(data.length>0){
                JSONArray jsonArray = new JSONArray(data[0]);
                swarmMeta.put("commandArguments", jsonArray);
            }

            swarmData.put("meta", swarmMeta);

        } catch (JSONException e) {
            e.printStackTrace();
        }

        this.ioSocket.emit("message", swarmData);
    }


    private void getIdentity(){
        startSwarm("login.js","getIdentity","authenticate");
    }

}
