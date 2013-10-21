package com.mlsdev.charityapp.models;

/**
 * Created by android-dev on 12.09.13.
 */
public class UserRequest {
    public String getId() {
        return id;
    }

    public String getDescription() {
        return description;
    }

    public String getDateTime() {
        return dateTime;
    }

    public String getHelpersCount() {
        return helpersCount;
    }

    String id;
    String description;
    String dateTime;
    String helpersCount;

    public UserRequest(String id, String description, String dateTime, String helpersCount) {
        this.id = id;
        this.description = description;
        this.dateTime = dateTime;
        this.helpersCount = helpersCount;
    }
}
