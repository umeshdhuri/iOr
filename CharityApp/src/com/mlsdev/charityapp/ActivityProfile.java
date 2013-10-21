package com.mlsdev.charityapp;

import android.app.AlertDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.util.SparseBooleanArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.countrypicker.CountryPicker;
import com.countrypicker.CountryPickerListener;
import com.mlsdev.charityapp.models.Category;

import java.util.ArrayList;
import java.util.Locale;

import static com.mlsdev.charityapp.Utils.log;

/**
 * Created by android-dev on 03.09.13.
 */
public class ActivityProfile extends DialogActivity {
    private static final String PREFS_NAME = "default prefs";
    private static final String SP_KEY_PHONE = "phone";
    private static final String SP_KEY_CODE = "code";
    private static final String SP_KEY_COUNTRY = "country";
    private static final String SP_KEY_NAME = "sponsor name";
    ArrayList<Category> mCategories = new ArrayList<Category>();
    ArrayList<String> mCategoryNames = new ArrayList<String>();
    ArrayList<Integer> mCategoryIds = new ArrayList<Integer>();


    TextView tvCode;
    EditText etCountry;
    EditText etName;

    ListView mLvCategories;
    private AlertDialog mSetSponsorDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile);
        showProgressDialog();
        new AsyncTask<Void, Void, ArrayList<Category>>(){

            @Override
            protected ArrayList<Category> doInBackground(Void... params) {
                mCategoryIds = Request.getProfile(ActivityProfile.this);
                return mCategories = Request.getCategories(ActivityProfile.this);
            }

            @Override
            protected void onPostExecute(ArrayList<Category> result) {
                closeProgressDialog();
                if(mCategories==null){
                    showErrorToast();
                } else {
                    setupViews();
                }
            }
        }.execute();
    }

    private void setupViews() {
        Button btSetSponsor = (Button)findViewById(R.id.btSetSponsor);
        btSetSponsor.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showSetSponsorDialog();
            }
        });


        for(Category category: mCategories){
            mCategoryNames.add(category.mName);
        }
        Button btSend = (Button) findViewById(R.id.btSend);
        btSend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showProgressDialog();
                new AsyncTask<Void, Void, String>(){

                    @Override
                    protected String doInBackground(Void... params) {
                        ArrayList<Integer> checkedItems = getCheckedItems();
                        SharedPreferences prefs = getSharedPreferences(PREFS_NAME,MODE_PRIVATE);

                        String country = prefs.getString(SP_KEY_COUNTRY,"");
                        if(!country.isEmpty()){
                            String code = prefs.getString(SP_KEY_CODE,"");
                            String phone = prefs.getString(SP_KEY_PHONE,"");
                            String name = prefs.getString(SP_KEY_NAME,"");
                            String fullPhone;
                            if(phone.isEmpty()){
                                fullPhone = "";
                            } else {
                                fullPhone = code.replace("+","")+phone;
                            }
                            if(Request.changeSponsor(ActivityProfile.this,name,fullPhone)==null) return null;
                        }
                        return  Request.updateProfile(ActivityProfile.this, checkedItems);
                    }

                    @Override
                    protected void onPostExecute(String result) {
                        closeProgressDialog();
                        if (result==null) {
                            showErrorToast();
                        } else {
                            showSuccessDialog();
                        }
                    }
                }.execute();
            }
        });
        mLvCategories = (ListView) findViewById(R.id.lv_categories);
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this,android.R.layout.simple_list_item_multiple_choice,mCategoryNames){


            @Override
            public View getView(int position, View convertView, ViewGroup parent) {
                View view = super.getView(position, convertView, parent);
                view.setBackgroundResource(R.drawable.item_background_selector);
                return view;
            }
        };
        mLvCategories.setAdapter(adapter);
        if(mCategoryIds!=null){
            for(int i=0;i<mCategories.size();i++){
                 mLvCategories.setItemChecked(i,mCategoryIds.contains(mCategories.get(i).mCategoryId));
            }
        }
    }

    private void showSetSponsorDialog() {
        AlertDialog.Builder builder;


        LayoutInflater inflater = (LayoutInflater)
                getSystemService(LAYOUT_INFLATER_SERVICE);
        View layout = inflater.inflate(R.layout.dialog_set_sponsor,
                (ViewGroup) findViewById(R.id.layout_root));


        builder = new AlertDialog.Builder(this);
        builder.setView(layout);
        builder.setCancelable(true);

        final EditText etSponsorPhone = (EditText) layout.findViewById(R.id.etPhone);
        etName = (EditText) layout.findViewById(R.id.etName);
        tvCode = (TextView) layout.findViewById(R.id.tvCountryCode);
        etCountry = (EditText) layout.findViewById(R.id.etCountry);


        etCountry.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                if(hasFocus) {
                    showCountryPicker();
                }
            }
        });
        etCountry.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showCountryPicker();
            }
        });

        SharedPreferences prefs = getSharedPreferences(PREFS_NAME,MODE_PRIVATE);
        String country = prefs.getString(SP_KEY_COUNTRY,"");
        String code = prefs.getString(SP_KEY_CODE,"");
        String phone = prefs.getString(SP_KEY_PHONE,"");
        String name = prefs.getString(SP_KEY_NAME,"");

        if(!prefs.getString(SP_KEY_COUNTRY,"").isEmpty()){
            etCountry.setText(country);
            tvCode.setText(code);
            etName.setText(name);
            etSponsorPhone.setText(phone);
        } else {
            TelephonyManager manager = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
            //getNetworkCountryIso

            String countryID= manager.getSimCountryIso().toUpperCase();
            Locale locale = new Locale("en",countryID);

            etCountry.setText(locale.getDisplayCountry(new Locale("en","US")));

            setCountry(countryID);
        }





        Button btNegative = (Button) layout.findViewById(R.id.btCancel);
        // if button is clicked, close the custom dialog
        btNegative.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mSetSponsorDialog.dismiss();
                log("XXX","onClick cancel");
            }
        });
        Button btPositive = (Button) layout.findViewById(R.id.btSet);
        // if button is clicked, close the custom dialog
        btPositive.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String sponsorPhone = etSponsorPhone.getText().toString();
                String sponsorCode = tvCode.getText().toString();
                String country = etCountry.getText().toString();
                String sponsorName = etName.getText().toString();


                if(sponsorName.isEmpty()){
                    ActivityProfile.this.showEmptyValueToast();
                } else {
                    saveSponsorPhone(sponsorPhone,sponsorCode,country,sponsorName);
                    mSetSponsorDialog.dismiss();
                }
                log("XXX","onClick send");
            }
        });

        builder.create();
        mSetSponsorDialog = builder.show();
    }

    private void setCountry(String countryID) {
            log("setCountry","countryID " + countryID);
            String[] countries = getResources().getStringArray(R.array.CountryCodes);
            for(int i=0;i<countries.length;i++){
                String[] country = countries[i].split(",");
                if(country[1].trim().equals(countryID.trim())){
                    tvCode.setText("+"+country[0]);
                    etCountry.setText(new Locale("en",countryID).getDisplayCountry(new Locale("en","US")));
                    break;
                }
            }
    }

    private void showCountryPicker() {
        final CountryPicker picker = new CountryPicker();
        picker.setListener(new CountryPickerListener() {

            @Override
            public void onSelectCountry(String name, String code) {
                setCountry(code);
                picker.dismiss();
            }
        });
        picker.show(getSupportFragmentManager(),"Country picker");
    }

    private void saveSponsorPhone(String sponsorPhone,String sponsorCode,String country,String name) {
        SharedPreferences prefs = getSharedPreferences(PREFS_NAME,MODE_PRIVATE);
        prefs.edit().putString(SP_KEY_PHONE,sponsorPhone).commit();
        prefs.edit().putString(SP_KEY_CODE,sponsorCode).commit();
        prefs.edit().putString(SP_KEY_COUNTRY,country).commit();
        prefs.edit().putString(SP_KEY_NAME,name).commit();
    }

    private void showSuccessDialog() {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        alertDialogBuilder
                .setMessage(getString(R.string.request_accepted))
                .setCancelable(true);
        AlertDialog alertDialog = alertDialogBuilder.create();
        alertDialog.show();
    }

    public ArrayList<Integer> getCheckedItems(){
        SparseBooleanArray checked = mLvCategories.getCheckedItemPositions();
        ArrayList<Integer> result = new ArrayList<Integer>();
        log("cheked", "checked size "+ checked.size());
        for (int i = 0; i < checked.size(); i++){
            log("cheked", i+" "+ checked.get(i));
            if (checked.get(i)){
                result.add(mCategories.get(i).mCategoryId);
                Log.v("categories", "checked " + i + " " + mCategories.get(i).mCategoryId);
            } else {
                //the item is not checked, do something else
            }
        }
        return result;
    }

}
