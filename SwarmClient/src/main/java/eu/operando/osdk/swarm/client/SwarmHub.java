package eu.operando.osdk.swarm.client;

import org.greenrobot.eventbus.EventBus;
import org.json.JSONObject;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import eu.operando.osdk.swarm.client.events.SwarmLoginEvent;
import eu.operando.osdk.swarm.client.events.SwarmLogoutEvent;
import eu.operando.osdk.swarm.client.utils.SwarmConstants;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;


/**
 * Created by Rafa on 4/5/2016.
 */
public class SwarmHub {

    private Socket ioSocket;
    private List<Swarm> swarms = new ArrayList<Swarm>();

    public SwarmHub(Socket socket) {
        this.ioSocket = socket;

        Emitter.Listener onNewMessage = new Emitter.Listener() {
            @Override
            public void call(final Object... args) {
                JSONObject data = (JSONObject) args[0];
                System.out.println(data);

                try {
                    JSONObject metaResponse = new JSONObject(data.get("meta").toString());
                    String swarmingName = metaResponse.getString(SwarmConstants.SWARMING_NAME);
                    String currentPhase = metaResponse.getString(SwarmConstants.CURRENT_PHASE);

                    System.out.println(swarmingName);
                    System.out.println(currentPhase);

                    Swarm swarm = new Swarm(swarmingName, currentPhase, data);
                    //swarms.add(swarm);
                    fireEvent(swarm);

                } catch (Exception e) {
                    System.err.println(e.getMessage());
                }
            }
        };

        this.ioSocket.on("message", onNewMessage);
    }

    private void fireEvent(Swarm swarm){

       String eventClassName = getEventTypeBySwarmPhase(swarm);

        Class<?> clazz = null;
        try {
            clazz = Class.forName(eventClassName);
            Constructor<?> constructor = clazz.getConstructor(String.class, String.class, JSONObject.class);
            Object instance = constructor.newInstance(swarm.getName(), swarm.getPhase(), swarm.getData());
            EventBus.getDefault().post(instance);

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }


    }


    private String getEventTypeBySwarmPhase(Swarm swarm){

        String className = "";

        if (swarm.getName().equals("login.js") && swarm.getPhase().equals("success")) {
            className = SwarmLoginEvent.class.getName();
        } else {
            className = SwarmLogoutEvent.class.getName();
        }

        return className;
    }

    public void on(String swarmName, String phase) {



    }


}
