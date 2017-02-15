package eu.operando.models;

import java.util.ArrayList;

/**
 * Created by Edy on 1/3/2017.
 */

public class Notification {
    private String notificationId;
    private String sender;
    private String type;
    private String category;
    private String title;
    private String description;
    private boolean dismissed;
    private ArrayList<Action> actions;

    public String getNotificationId() {
        return notificationId;
    }

    public String getSender() {
        return sender;
    }

    public String getType() {
        return type;
    }

    public String getCategory() {
        return category;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public boolean isDismissed() {
        return dismissed;
    }

    public ArrayList<Action> getActions() {
        return actions;
    }

    public class Action{
        String key;
        String title;

        public String getKey() {
            return key;
        }

        public String getTitle() {
            return title;
        }
    }
}
