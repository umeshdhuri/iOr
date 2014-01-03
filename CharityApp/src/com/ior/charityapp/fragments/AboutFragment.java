package com.ior.charityapp.fragments;

/**
 * Created by android-dev on 09.09.13.
 */

import java.util.ArrayList;
import java.util.Arrays;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.opengl.Visibility;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.Spannable;
import android.text.SpannableString;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.RadioGroup;

import com.ior.charityapp.lang.StringPicker;
import com.ior.charityapp.lang.ViewProcessor;
import com.ior.charityappior.ActivityMain;
import com.ior.charityappior.ActivityNeedHelp;
import com.ior.charityappior.DialogActivity;
import com.ior.charityappior.Request;
import com.ior.charityappior.R;

import static com.ior.charityappior.Utils.log;

public class AboutFragment extends ParentFragment {

	private static final String ARG_POSITION = "position";

	private int position;
	private StringPicker stringPicker;

	private String[] strings_about;
	Button changeLagnBtn;
	TextView tvText;
	LinearLayout languageLayout;
	private RadioButton radioLangButton, radioEngBtn, radioHeBtn;
	private RadioGroup radioLangGroup;
	View root;
	String tempLang, langVal;
	String languageResponse;
	private ProgressDialog progressDialog;
	int selectedRadioBtn;
	public static AboutFragment newInstance(int position) {
		log("About View", "position === " + position);
		
		AboutFragment f = new AboutFragment();
		Bundle b = new Bundle();
		b.putInt(ARG_POSITION, position);
		f.setArguments(b);
		return f;
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		stringPicker = new StringPicker(getActivity(), getLanguageFileName());
		strings_about = new String[] { stringPicker.getString("description"),
				stringPicker.getString("concept"),
				"Change Language Text"
		};

		position = getArguments().getInt(ARG_POSITION);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {

		root = inflater.inflate(R.layout.fragment_about, container, false);
		tvText = (TextView) root.findViewById(R.id.tvAbout);
		languageLayout = (LinearLayout) root.findViewById(R.id.changePassLayout);
		changeLagnBtn = (Button) root.findViewById(R.id.btnDisplay);
		radioLangGroup = (RadioGroup) root.findViewById(R.id.radioLanguage);
		radioEngBtn = (RadioButton) root.findViewById(R.id.radioEnglish);
		radioHeBtn = (RadioButton) root.findViewById(R.id.radioHebrew);
		
		if(getActivity().getSharedPreferences("app_settings", Context.MODE_PRIVATE).getString("lang", "").equalsIgnoreCase("English")) {
			radioLangGroup.check(radioEngBtn.getId());
			changeLagnBtn.setText("Change Language");
        }else if(getActivity().getSharedPreferences("app_settings", Context.MODE_PRIVATE).getString("lang", "").equalsIgnoreCase("Hebrew")) {
        	radioLangGroup.check(radioHeBtn.getId());
        	changeLagnBtn.setText("החלף שפה");
        }
		
		
		languageLayout.setVisibility(View.GONE);
		log("About View", "position === " + position);
		String descText = strings_about[position];
		Spannable spanText = new SpannableString(strings_about[position]);
		log("About View", "spanText === " + descText);
		if(descText.equalsIgnoreCase("Change Language Text")) {
			tvText.setVisibility(View.GONE);
			languageLayout.setVisibility(View.VISIBLE);
			
			changeLagnBtn.setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View arg0) {
					// TODO Auto-generated method stub
					
					// get selected radio button from radioGroup
					int selectedId = radioLangGroup.getCheckedRadioButtonId();
		 
					// find the radiobutton by returned id
				        radioLangButton = (RadioButton) root.findViewById(selectedId);
				        langVal = (String) radioLangButton.getTag();
				        if(langVal.length() > 0) {
				        	
				        	if(langVal.equalsIgnoreCase("0")) {
				        		tempLang = "English";
				        		progressDialog = ProgressDialog.show(getActivity(), "",
										"Sending request");
				        	}else{
				        		tempLang = "Hebrew";
				        		progressDialog = ProgressDialog.show(getActivity(), "",
										"שולח בקשה");
				        	}
				        	progressDialog.show();
				        	new changeLanguage().execute();
			    		}
					
				}
				
			});
			
			
		}else{
			changeLagnBtn.setVisibility(View.GONE);
			tvText.setText(spanText);
		}
		
		return root;

		/*
		 * LayoutParams params = new LayoutParams(LayoutParams.MATCH_PARENT,
		 * LayoutParams.MATCH_PARENT);
		 * 
		 * FrameLayout fl = new FrameLayout(getActivity());
		 * fl.setLayoutParams(params);
		 * 
		 * final int margin = (int)
		 * TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 8,
		 * getResources() .getDisplayMetrics());
		 * 
		 * TextView v = new TextView(getActivity()); params.setMargins(margin,
		 * margin, margin, margin); v.setLayoutParams(params);
		 * v.setLayoutParams(params); v.setGravity(Gravity.CENTER);
		 * v.setBackgroundResource(R.drawable.background_card);
		 * v.setText(getResources().getString(R.string.about)); fl.addView(v);
		 * return fl;
		 */
	}
	
	private class changeLanguage extends AsyncTask<String, Void, Integer> {

		@Override
		protected void onPreExecute() {
			super.onPreExecute();
		}

		@Override
		protected Integer doInBackground(String... params) {
			changeLanguageSync();
			return 1;
		}

		@Override
		protected void onPostExecute(Integer result) {
			super.onPostExecute(result);
			
			//((ActivityMain) getActivity()).closeProgressDialog();
			if (languageResponse == null) {
				
				if (progressDialog.isShowing()) {
					progressDialog.dismiss();
				}
				
			} else {
				
				if (progressDialog.isShowing()) {
					progressDialog.dismiss();
				}
				
				
					
				getActivity().getSharedPreferences("app_settings",
						Context.MODE_PRIVATE).edit()
				.putString("lang", tempLang).commit();
				
				 try {
						ViewProcessor.process(getActivity(), (ViewGroup) getActivity().getWindow().getDecorView()
								.getRootView(), getLanguageFileName());
					} catch (Exception ex) {
						ex.printStackTrace();
					}
				 
				 Intent intent = new Intent(getActivity(), ActivityMain.class);
				 intent.putExtra("ChangeLanguage",true);
				 startActivity(intent);
				 	
			}
		}
		
	}
	
	private void changeLanguageSync() {
		
		String passLang = "";
		if(tempLang.equalsIgnoreCase("English")) {
			passLang = "";
		}else{
			passLang = "he";
		}
		
		//log("Token Key", getActivity().getSharedPreferences("app_settings", Context.MODE_PRIVATE).getString("TOKEN_KEY", null));
		String TokenValue = getActivity().getSharedPreferences("app_settings", Context.MODE_PRIVATE).getString("TOKEN_KEY", null);
        
		languageResponse = Request.updateLanguage(getActivity(), passLang);
	}
	
}
