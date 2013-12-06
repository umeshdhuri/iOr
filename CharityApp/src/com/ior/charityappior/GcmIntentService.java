package com.ior.charityappior;


import android.app.IntentService;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.SystemClock;
import android.support.v4.app.NotificationCompat;

import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.ior.charityappior.R;

import static com.ior.charityappior.Utils.log;

/**
 * Created by android-dev on 29.08.13.
 */
public class GcmIntentService extends IntentService {
    public static final int NOTIFICATION_ID = 1;
    private static final String TAG = "GCM";
    private NotificationManager mNotificationManager;
    NotificationCompat.Builder builder;
    private SharedPreferences pref;
	private SharedPreferences.Editor editer;

	 String notification_header;
     String notification_body;
     
    public GcmIntentService() {
        super("GcmIntentService");
    }


    // Put the message into a notification and post it.
    // This is just one simple example of what you might choose to do with
    // a GCM message.

    @Override
    protected void onHandleIntent(Intent intent) {
        log("gcm","onHandleIntent");
        Bundle extras = intent.getExtras();
        GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(this);
        // The getMessageType() intent parameter must be the intent you received
        // in your BroadcastReceiver.
        String messageType = gcm.getMessageType(intent);

        if (!extras.isEmpty()) {  // has effect of unparcelling Bundle
            /*
             * Filter messages based on message type. Since it is likely that GCM
             * will be extended in the future with new message types, just ignore
             * any message types you're not interested in, or that you don't
             * recognize.
             */
            if (GoogleCloudMessaging.
                    MESSAGE_TYPE_SEND_ERROR.equals(messageType)) {
                sendNotification("Send error: " + extras.toString(),"",null);
            } else if (GoogleCloudMessaging.
                    MESSAGE_TYPE_DELETED.equals(messageType)) {
                sendNotification("Deleted messages on server: " +
                        extras.toString(),"",null);
                // If it's a regular GCM message, do some work.
            } else if (GoogleCloudMessaging.
                    MESSAGE_TYPE_MESSAGE.equals(messageType)) {
                // This loop represents the service doing some work.

                log(TAG, "Completed work @ " + SystemClock.elapsedRealtime());
                // Post notification of received message.
                log("message ===", extras.getString("message"));
                log("user_name ===", extras.getString("user_name"));
                log("help_request_id ===", extras.getString("help_request_id"));
                
                sendNotification(extras.getString("message"), extras.getString("user_name"), extras.getString("help_request_id"));
                log(TAG, "Received: " + extras.toString());
            }
        }
        // Release the wake lock provided by the WakefulBroadcastReceiver.
        GcmBroadcastReceiver.completeWakefulIntent(intent);

    }

    private void sendNotification(String msg, String name,String id) {
        log("gcm","sendNotification");
        mNotificationManager = (NotificationManager)
                this.getSystemService(Context.NOTIFICATION_SERVICE);
        Intent intent = new Intent(this, ActivityMain.class);
        intent.putExtra("notif",true);
        intent.putExtra("message",msg);
        intent.putExtra("name",name);
        intent.putExtra("request_id",id);

        PendingIntent contentIntent = PendingIntent.getActivity(this, 0,
                intent, PendingIntent.FLAG_UPDATE_CURRENT);

        pref = this.getSharedPreferences("app_settings", MODE_PRIVATE);
		editer = pref.edit();

       
        
        if(pref.getString("lang", "").equalsIgnoreCase("English")) {
        		notification_header = "Need help!";
        		notification_body = " needs help with ";
	        }else if(pref.getString("lang", "").equalsIgnoreCase("Hebrew")) {
	        	notification_header = "!צריך/ה עזרה";
	        	notification_body = " צריך/ה עזרה עם ";
	        }
        
        
        NotificationCompat.Builder mBuilder =
                new NotificationCompat.Builder(this)
                        .setSmallIcon(R.drawable.ic_launcher)
                        .setContentTitle(notification_header)
                        .setStyle(new NotificationCompat.BigTextStyle()
                                .bigText(msg))
                        .setAutoCancel(true)
                        .setContentText(name+ notification_body + msg+ "!!!");

        mBuilder.setContentIntent(contentIntent);
        Notification notif = mBuilder.build();
        notif.defaults |= Notification.DEFAULT_SOUND;
        notif.defaults |= Notification.DEFAULT_VIBRATE;
        mNotificationManager.notify(NOTIFICATION_ID, notif);
    }
}
