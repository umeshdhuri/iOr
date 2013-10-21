package com.mlsdev.charityapp;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;

import com.countrypicker.CountryPicker;
import com.countrypicker.CountryPickerListener;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.mlsdev.charityapp.fragments.LoginFragment;
import com.mlsdev.charityapp.fragments.MainScreenFragment;

import java.io.IOException;
import java.util.Timer;
import java.util.TimerTask;

import static com.mlsdev.charityapp.Utils.getToken;
import static com.mlsdev.charityapp.Utils.log;

public class ActivityMain extends DialogActivity {

    public static final String EXTRA_MESSAGE = "message";
    public static final String PROPERTY_REG_ID = "registration_id";
    private static final String PROPERTY_APP_VERSION = "appVersion";
    private final static int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
    private static final String TAG = "GCM";


    public static final String SENDER_ID = "527685080878";


    GoogleCloudMessaging gcm;
    SharedPreferences prefs;
    Context context;

    Timer mTimer;



    String mPhoneNumber;

    String regid;
    private String mName;

    public String getPhoneNumber() {
        return mPhoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        mPhoneNumber = phoneNumber;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        getSupportActionBar().hide();
        setContentView(R.layout.fragment_holder);

        context = getApplicationContext();

        // Check device for Play Services APK. If check succeeds, proceed with
        //  GCM registration.
        if (checkPlayServices()) {
            gcm = GoogleCloudMessaging.getInstance(this);
            regid = getRegistrationId();

            if (regid.isEmpty()) {
                registerInBackground();
            }
        } else {
            log(TAG, "No valid Google Play Services APK found.");
        }

        if (getToken(this)!= null&&!Utils.TEST){
            setFragment(new MainScreenFragment());
        } else {
            setFragment(new LoginFragment());
        }

        if(mTimer==null){
            mTimer = new Timer();
            mTimer.schedule(new TimerTask() {
                @Override
                public void run() {
                    Request.updateCoordinates(ActivityMain.this);
                }
            },1000,5*60*1000);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        log("handle message", "onResume");
        if(getIntent().getBooleanExtra("notif",false)){
            String message = getIntent().getStringExtra("message");
            String requestId = getIntent().getStringExtra("request_id");
            String name = getIntent().getStringExtra("name");
            showAcceptRequestDialog(message,name,requestId);
        }
        checkPlayServices();
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        log("handle message", "onResume");
        if(intent.getBooleanExtra("notif", false)){
            String message = intent.getStringExtra("message");
            String name = intent.getStringExtra("name");
            String requestId = intent.getStringExtra("request_id");
            showAcceptRequestDialog(message,name,requestId);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if(mTimer!=null){
            mTimer.cancel();
        }
    }

    private AlertDialog showAcceptRequestDialog(String description,String userName, final String requestId) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);

        alertDialogBuilder.setMessage(userName +" needs help with " + description +". Can you help him?");
        alertDialogBuilder.setCancelable(false)
                .setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        setIntent(new Intent(ActivityMain.this,ActivityMain.class));
                        showProgressDialog();
                        new AsyncTask<Void, Void, String>() {

                            @Override
                            protected String doInBackground(Void... params) {
                                return Request.acceptHelpRequest(ActivityMain.this, requestId);
                            }

                            @Override
                            protected void onPostExecute(String s) {
                                closeProgressDialog();
                                if (s == null) {
                                    showErrorToast();
                                } else {
                                    showAcceptedDialog();
                                }
                            }
                        }.execute();
                    }
                })
                .setNegativeButton("No", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        setIntent(new Intent(ActivityMain.this,ActivityMain.class));
                        dialog.cancel();
                    }
                });

        AlertDialog alertDialog = alertDialogBuilder.create();

        alertDialog.show();
        return  alertDialog;
    }

    private void showAcceptedDialog() {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);

        alertDialogBuilder.setMessage("Your answer is accepted. Wait for the call");
        alertDialogBuilder.setCancelable(true)
                .setPositiveButton("ОК", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.cancel();
                    }
                });
        AlertDialog alertDialog = alertDialogBuilder.create();
        alertDialog.show();

    }

    /**
     * Registers the application with GCM servers asynchronously.
     * <p>
     * Stores the registration ID and app versionCode in the application's
     * shared preferences.
     */
    private void registerInBackground() {
        log("pushid", "registerInBackground");
        new AsyncTask<Void,Void,String>() {


            @Override
            protected String doInBackground(Void... params) {
                String msg = "";
                try {
                    if (gcm == null) {
                        gcm = GoogleCloudMessaging.getInstance(context);
                    }
                    regid = gcm.register(SENDER_ID);
                    msg = "Device registered, registration ID=" + regid;
                    log("pushid",msg);

                    // You should send the registration ID to your server over HTTP,
                    // so it can use GCM/HTTP or CCS to send messages to your app.
                    // The request to your server should be authenticated if your app
                    // is using accounts.
                    sendRegistrationIdToBackend();

                    // For this demo: we don't need to send it because the device
                    // will send upstream messages to a server that echo back the
                    // message using the 'from' address in the message.

                    // Persist the regID - no need to register again.
                    storeRegistrationId(context, regid);
                } catch (IOException ex) {
                    msg = "Error :" + ex.getMessage();
                    log("pushid",msg);
                    // If there is an error, don't just keep trying to register.
                    // Require the user to click a button again, or perform
                    // exponential back-off.
                }
                return msg;
            }

            @Override
            protected void onPostExecute(String s) {

            }
        }.execute();



        /**
         * Sends the registration ID to your server over HTTP, so it can use GCM/HTTP
         * or CCS to send messages to your app. Not needed for this demo since the
         * device sends upstream messages to a server that echoes back the message
         * using the 'from' address in the message.
         */

    }

    private void sendRegistrationIdToBackend() {
        // Your implementation here.
    }

    private void storeRegistrationId(Context context, String regId) {
        final SharedPreferences prefs = getGCMPreferences(context);
        int appVersion = getAppVersion(context);
        log(TAG, "Saving regId on app version " + appVersion);
        SharedPreferences.Editor editor = prefs.edit();
        editor.putString(PROPERTY_REG_ID, regId);
        editor.putInt(PROPERTY_APP_VERSION, appVersion);
        editor.commit();
    }



    public String getRegistrationId() {
        log(TAG, "getRegistrationId");
        final SharedPreferences prefs = getGCMPreferences(context);
        String registrationId = prefs.getString(PROPERTY_REG_ID, "");
        if (registrationId.isEmpty()) {
            log(TAG, "Registration not found.");
            return "";
        }
        // Check if app was updated; if so, it must clear the registration ID
        // since the existing regID is not guaranteed to work with the new
        // app version.
        int registeredVersion = prefs.getInt(PROPERTY_APP_VERSION, Integer.MIN_VALUE);
        int currentVersion = getAppVersion(context);
        if (registeredVersion != currentVersion) {
            log(TAG, "App version changed.");
            return "";
        }
        log(TAG, registrationId);
        return registrationId;
    }

    private static int getAppVersion(Context context) {
        try {
            PackageInfo packageInfo = context.getPackageManager()
                    .getPackageInfo(context.getPackageName(), 0);
            return packageInfo.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            // should never happen
            throw new RuntimeException("Could not get package name: " + e);
        }
    }
    /**
     * @return Application's {@code SharedPreferences}.
     */
    private SharedPreferences getGCMPreferences(Context context) {
        // This sample app persists the registration ID in shared preferences, but
        // how you store the regID in your app is up to you.
        return getSharedPreferences(ActivityMain.class.getSimpleName(),
                Context.MODE_PRIVATE);
    }








    private boolean checkPlayServices() {
        int resultCode = GooglePlayServicesUtil.isGooglePlayServicesAvailable(this);
        if (resultCode != ConnectionResult.SUCCESS) {
            if (GooglePlayServicesUtil.isUserRecoverableError(resultCode)) {
                GooglePlayServicesUtil.getErrorDialog(resultCode, this,
                        PLAY_SERVICES_RESOLUTION_REQUEST).show();
            } else {
                Log.i(TAG, "This device is not supported.");
                finish();
            }
            return false;
        }
        return true;
    }

    public void setFragment(Fragment fragment){
        FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
        ft.setCustomAnimations(android.R.anim.slide_in_left,android.R.anim.slide_out_right);
        ft.replace(R.id.fragment, fragment);
        ft.commit();
    }


    /*@Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }*/

    public void setName(String name) {
        this.mName = name;
    }

    public String getName() {
        return mName;
    }

    public void showCountryPicker(final LoginFragment loginFragment) {
        final CountryPicker picker = new CountryPicker();
        picker.setListener(new CountryPickerListener() {

            @Override
            public void onSelectCountry(String name, String code) {
                loginFragment.setCountry(code);
                picker.dismiss();
            }
        });
        picker.show(getSupportFragmentManager(),"Country picker");
    }
}
