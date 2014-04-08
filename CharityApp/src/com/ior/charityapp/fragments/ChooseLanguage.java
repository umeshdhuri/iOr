package com.ior.charityapp.fragments;

import java.util.ArrayList;

import java.util.Arrays;
import java.util.List;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;

import com.ior.charityapp.lang.ViewProcessor;
import com.ior.charityappior.ActivityAbout;
import com.ior.charityappior.ActivityNeedHelp;
import com.ior.charityappior.ActivityProfile;
import com.ior.charityappior.ActivityRequests;


import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.Toast;
import com.ior.charityappior.R;


public class ChooseLanguage extends Activity implements OnClickListener {

	String[] language;
	int selectedPosition;
	String lang;
	private AlertDialog.Builder builder;
	public static final int CHANGE_LANGUAGE_VALUE = 101; 
	private SharedPreferences pref;
	private SharedPreferences.Editor editer;
	private LinearLayout dialogLinnerLayout;
	public static final int DELAYED_RESPONSE = 700;
	private Handler handler = new Handler();
	
	@SuppressLint("NewApi")
	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.language_spinner);
        this.setFinishOnTouchOutside(true);
        
        
        dialogLinnerLayout = (LinearLayout) findViewById(R.id.dialogLinner);
        dialogLinnerLayout.setOnClickListener(this);
        
        
        final CharSequence[] items = {"English", "Hebrew"};
        selectedPosition = 0;
        
        builder = new AlertDialog.Builder(this);
        builder.setTitle("Choose an option"); 
        builder.setCancelable(true).show();
        
        pref = this.getSharedPreferences("app_settings", MODE_PRIVATE);
		editer = pref.edit();
		
		
        if(pref.getString("lang", "").equalsIgnoreCase("English")) {
        	selectedPosition = 0;
        }else if(pref.getString("lang", "").equalsIgnoreCase("Hebrew")) {
        	selectedPosition = 1;
        }
        
        
        builder.setSingleChoiceItems(items, selectedPosition, new  DialogInterface.OnClickListener() { 
          public void  onClick(DialogInterface dialog, int item) {
        	  selectedPosition = ((AlertDialog)dialog).getListView().getCheckedItemPosition();
               dialog.dismiss();
               
               Intent back_result_intent = getIntent();
               back_result_intent.putExtra("langTemp", (String) items[item]);
               Toast.makeText(getApplicationContext(), items[item],  Toast.LENGTH_SHORT).show();
               setResult(101, back_result_intent);
               finish();
          } 
       });
       
       final AlertDialog alert = builder.create();
       alert.show();
       
      
       
        //Spinner spinner = (Spinner) findViewById(R.id.spinner_language);
		
		//ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource( 
				//this, R.array.languages, android.R.layout.simple_spinner_item);

				//adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
				//spinner.setAdapter(adapter);
				
	}
	
	

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		// finish();
		
	}
	
	public void onBackPressed(){
	     // do something here and don't write super.onBackPressed()
		
		Intent back_result_intent = getIntent();
        back_result_intent.putExtra("langTemp", (String) "");
        setResult(101, back_result_intent);
        finish();
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
	    if (keyCode == KeyEvent.KEYCODE_BACK) {
	        moveTaskToBack(true);
	        return true;
	    }
	    return super.onKeyDown(keyCode, event);
	}
	
}
