package eu.operando.osdk.swarm.client;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

/**
 * Created by Rafa on 4/5/2016.
 */

@Deprecated
public class SwarmCommand {

    public String swarmingName;
    public String command;
    public String ctor;
    public String tenantId;
    public String[] commandArguments;


    public SwarmCommand (String swarmingName, String command, String ctor, String tenantId, String[] commandArguments){
        this.swarmingName = swarmingName;
        this.command = command;
        this.ctor = ctor;
        this.tenantId = tenantId;
        this.commandArguments = commandArguments;
    }

    public  SwarmCommand(){

    }

    public String getSwarmingName() {
        return swarmingName;
    }

    public void setSwarmingName(String swarmingName) {
        this.swarmingName = swarmingName;
    }

    public String getCommand() {
        return command;
    }

    public void setCommand(String command) {
        this.command = command;
    }

    public String getCtor() {
        return ctor;
    }

    public void setCtor(String ctor) {
        this.ctor = ctor;
    }

    public String getTenantId() {
        return tenantId;
    }

    public void setTenantId(String tenantId) {
        this.tenantId = tenantId;
    }

    public String[] getCommandArguments() {
        return commandArguments;
    }

    public void setCommandArguments(String[] commandArguments) {
        this.commandArguments = commandArguments;
    }

    public JsonObject getJson() {
        Gson gsonObject = new Gson();
        JsonObject object = new JsonObject();

        object.add("meta", gsonObject.toJsonTree(this));
        return object;
    }

}
