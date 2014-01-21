package com.ior.charityapp.models;

/**
 * Created by android-dev on 27.08.13.
 */
public class Helper {
    public String mPhoneNumber;
    public String mName;
    public String mDistance;
    public String mDateTime;

    public int id;
    public String pushId;

    public Helper(String name, String distance, String phoneNumber, int id, String pushId,String dateTime){
        this.id=id;
        this.pushId=pushId;
        mName = name;
        mDistance = distance;
        mPhoneNumber = phoneNumber;
        mDateTime = dateTime;
    }
}
