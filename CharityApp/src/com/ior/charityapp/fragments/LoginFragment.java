package com.ior.charityapp.fragments;

import static com.ior.charityappior.Utils.log;

import java.util.Locale;

import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;

import com.ior.charityapp.lang.ViewProcessor;
import com.ior.charityappior.ActivityMain;
import com.ior.charityappior.DialogActivity;
import com.ior.charityappior.Request;
import com.ior.charityappior.Utils;
import com.ior.charityappior.R;

/**
 * Created by android-dev on 27.08.13.
 */
public class LoginFragment extends ParentFragment {
	private EditText etCountry;
	private TextView tvCountryCode;
	private View root;
	Spinner spinLang;
	private Button login;
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		// reset language to English
		getActivity()
				.getSharedPreferences("app_settings", Context.MODE_PRIVATE)
				.edit().putString("lang", "English").commit();

		root = inflater.inflate(R.layout.fragment_login, container, false);
		setupViews(root);
		return root;
	}

	private void setupViews(final View root) {

		spinLang = (Spinner) root.findViewById(R.id.spin_lang);
		tvCountryCode = (TextView) root.findViewById(R.id.tvCountryCode);

		final EditText etName = (EditText) root.findViewById(R.id.etName);
		final EditText etPhone = (EditText) root.findViewById(R.id.etPhone);

		TelephonyManager manager = (TelephonyManager) getActivity()
				.getSystemService(Context.TELEPHONY_SERVICE);
		// getNetworkCountryIso

		String countryID = manager.getSimCountryIso().toUpperCase();
		Locale locale = new Locale("en", countryID);

		etCountry = (EditText) root.findViewById(R.id.etCountry);

		etCountry.setText(locale.getDisplayCountry(new Locale("en", "US")));
		etCountry.setOnFocusChangeListener(new View.OnFocusChangeListener() {
			@Override
			public void onFocusChange(View v, boolean hasFocus) {
				if (hasFocus) {
					((ActivityMain) getActivity())
							.showCountryPicker(LoginFragment.this);
				}
			}
		});
		etCountry.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				((ActivityMain) getActivity())
						.showCountryPicker(LoginFragment.this);
			}
		});

		setCountry(countryID);
		
		login = (Button) root.findViewById(R.id.btLogin);
		
		spinLang.setOnItemSelectedListener(new OnItemSelectedListener() {

			@Override
			public void onItemSelected(AdapterView<?> arg0, View arg1,
					int arg2, long arg3) {
				// TODO Auto-generated method stub
				if(arg2 == 0) {
					login.setText("Register");
				}else {
					login.setText("הרשמה");
				}
				
			}

			@Override
			public void onNothingSelected(AdapterView<?> arg0) {
				// TODO Auto-generated method stub
				
			}

		  
		});

		
		login.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				
				String firstDigit = etPhone.getText().toString().substring(0, 1);
				String phoneNumberUser;
				if(firstDigit.equals("0")) {
					phoneNumberUser = etPhone.getText().toString().substring(1);
				}else{
					phoneNumberUser = etPhone.getText().toString();
				}
			
				final String phoneNumber = tvCountryCode.getText().toString()
						.replace("+", "")
						+ phoneNumberUser;
				log("phoneNumber", "phoneNumber " + phoneNumber);
				
				getActivity().getSharedPreferences("app_settings", Context.MODE_PRIVATE).edit()
				.putString("countryCode", tvCountryCode.getText().toString().replace("+", "")).commit();
				
				final String name = etName.getText().toString();

				if (phoneNumber.isEmpty() || name.isEmpty()) {
					((DialogActivity) getActivity()).showEmptyValueToast();
					return;
				}
				((ActivityMain) getActivity()).showProgressDialog();

				// update language preference
				String lang = (String) spinLang.getSelectedItem();
				getActivity()
						.getSharedPreferences("app_settings",
								Context.MODE_PRIVATE).edit()
						.putString("lang", lang).commit();
				try {
					ViewProcessor.process(getActivity(), (ViewGroup) getActivity().getWindow().getDecorView()
							.getRootView(), getLanguageFileName());
				} catch (Exception ex) {
					ex.printStackTrace();
				}
				

				new AsyncTask<Void, Void, String>() {

					@Override
					protected String doInBackground(Void... params) {
						log("pushId",
								"pushId "
										+ ((ActivityMain) getActivity())
												.getRegistrationId());
						((ActivityMain) getActivity())
								.setPhoneNumber(phoneNumber);
						((ActivityMain) getActivity()).setName(name);
						return Request.registerUser(name,
								((ActivityMain) getActivity())
										.getRegistrationId(), phoneNumber, getActivity());
					}

					@Override
					protected void onPostExecute(String result) {
						((ActivityMain) getActivity()).closeProgressDialog();
						if (Utils.TEST) {
							
							((ActivityMain) getActivity())
									.setFragment(new SendCodeFragment());
						} else {
							if (result.equals("Error")) {
								((ActivityMain) getActivity()).showErrorToast();
							} else {
								((ActivityMain) getActivity())
										.setFragment(new SendCodeFragment());
							}
						}
					}
				}.execute();
			}
		});
	}

	public void setCountry(String countryID) {
		log("setCountry", "countryID " + countryID);
		String[] countries = this.getResources().getStringArray(
				R.array.CountryCodes);
		for (int i = 0; i < countries.length; i++) {
			String[] country = countries[i].split(",");
			if (country[1].trim().equals(countryID.trim())) {
				tvCountryCode.setText("+" + country[0]);
				String c = new Locale("en", countryID)
						.getDisplayCountry(new Locale("en", "US"));
				etCountry.setText(c);
				
				Spinner spinLang = (Spinner) root
						.findViewById(R.id.spin_lang);
				if (c.equalsIgnoreCase("israel")) {
					spinLang.setSelection(1);
				} else {
					spinLang.setSelection(0);
				}
				break;
			}
		}
	}
}
