package com.mlsdev.charityapp.fragments;

import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.telephony.TelephonyManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.mlsdev.charityapp.ActivityMain;
import com.mlsdev.charityapp.DialogActivity;
import com.mlsdev.charityapp.R;
import com.mlsdev.charityapp.Request;
import com.mlsdev.charityapp.Utils;

import java.util.Locale;

import static com.mlsdev.charityapp.Utils.log;

/**
 * Created by android-dev on 27.08.13.
 */
public class LoginFragment extends Fragment {
    EditText etCountry;
    TextView tvCountryCode;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View root = inflater.inflate(R.layout.fragment_login, container, false);
        setupViews(root);
        return root;
    }

    private void setupViews(View root) {

        tvCountryCode = (TextView) root.findViewById(R.id.tvCountryCode);

        final EditText etName = (EditText) root.findViewById(R.id.etName);
        final EditText etPhone = (EditText) root.findViewById(R.id.etPhone);


        TelephonyManager manager = (TelephonyManager) getActivity().getSystemService(Context.TELEPHONY_SERVICE);
        //getNetworkCountryIso

        String countryID= manager.getSimCountryIso().toUpperCase();
        Locale locale = new Locale("en",countryID);


        etCountry = (EditText) root.findViewById(R.id.etCountry);


        etCountry.setText(locale.getDisplayCountry(new Locale("en","US")));
        etCountry.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                if(hasFocus) {
                    ((ActivityMain)getActivity()).showCountryPicker(LoginFragment.this);
                }
            }
        });
        etCountry.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((ActivityMain)getActivity()).showCountryPicker(LoginFragment.this);
            }
        });

        setCountry(countryID);

        Button login = (Button)root.findViewById(R.id.btLogin);

        login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final String phoneNumber = tvCountryCode.getText().toString().replace("+","")+etPhone.getText().toString();
                log("phoneNumber","phoneNumber " + phoneNumber);
                final String name = etName.getText().toString();

                if(phoneNumber.isEmpty()||name.isEmpty()){
                    ((DialogActivity)getActivity()).showEmptyValueToast();
                    return;
                }
                ((ActivityMain)getActivity()).showProgressDialog();
                new AsyncTask<Void,Void,String>(){

                    @Override
                    protected String doInBackground(Void... params) {
                        log("pushId","pushId " + ((ActivityMain)getActivity()).getRegistrationId());
                        ((ActivityMain)getActivity()).setPhoneNumber(phoneNumber);
                        ((ActivityMain)getActivity()).setName(name);
                        return Request.registerUser(name, ((ActivityMain)getActivity()).getRegistrationId(), phoneNumber);
                    }


                    @Override
                    protected void onPostExecute(String result) {
                        ((ActivityMain)getActivity()).closeProgressDialog();
                        if(Utils.TEST){
                            ((ActivityMain)getActivity()).setFragment(new SendCodeFragment());
                        } else {
                            if(result.equals("Error")){
                                ((ActivityMain)getActivity()).showErrorToast();
                            } else {
                                ((ActivityMain)getActivity()).setFragment(new SendCodeFragment());
                            }
                        }
                    }
                }.execute();
            }
        });
    }

    public void setCountry(String countryID){
        log("setCountry","countryID " + countryID);
        String[] countries = this.getResources().getStringArray(R.array.CountryCodes);
        for(int i=0;i<countries.length;i++){
            String[] country = countries[i].split(",");
            if(country[1].trim().equals(countryID.trim())){
                tvCountryCode.setText("+"+country[0]);
                etCountry.setText(new Locale("en",countryID).getDisplayCountry(new Locale("en","US")));
                break;
            }
        }
    }
}
