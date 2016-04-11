package eu.operando.osdk.swarm.client.utils;


import java.util.HashMap;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.List;
import java.util.ServiceLoader;
import java.util.Set;

import eu.operando.osdk.swarm.client.events.ISwarmEvent;
import eu.operando.osdk.swarm.client.events.SwarmEvent;
import eu.operando.osdk.swarm.client.events.SwarmLoginEvent;

/**
 * Created by Rafa on 4/7/2016.
 */
public class EventProvider {
    private static EventProvider instance = null;

    Hashtable<String, HashMap<String, Class>> eventDictionary = new Hashtable<>();

    public EventProvider(){

    }

    public static EventProvider getInstance() {
        if (instance == null) {

            instance = new EventProvider();
        }
        return instance;
    }


    //public getInstance


    public String getEvent(String swarmName, String swarmPhase){

       // HashMap<String, String> phases = eventDictionary.get("swarmName");
      //  phases.get(swarmPhase);

        return "eventClass";
    }

}
