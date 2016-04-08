package eu.operando.osdk.swarm.client;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by Rafa on 4/5/2016.
 */
@Deprecated
public class SwarmResponse {

    private JSONObject response;


    public Object getField(String fieldName) {
        try {
            return this.response.get(fieldName);
        } catch (JSONException e) {
            return null;
        }
    }

    public SwarmResponse(JSONObject response) {
            this.response = response;
    }


}
