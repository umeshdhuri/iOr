package com.ior.charityappior;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.ViewGroup;
import android.widget.Toast;

import com.ior.charityapp.lang.StringPicker;
import com.ior.charityapp.lang.ViewProcessor;

/**
 * Created by android-dev on 30.08.13.
 */
public class DialogActivity extends ActionBarActivity {

	private ProgressDialog mProgressDialog;
	protected StringPicker stringPicker;
	private SharedPreferences pref;
	private String sendingMsg;

	public void showProgressDialog() {
		pref = this.getSharedPreferences("app_settings", MODE_PRIVATE);
		if (pref.getString("lang", "").equalsIgnoreCase("English")) {
			sendingMsg = "Sending request";
		} else if (pref.getString("lang", "").equalsIgnoreCase("Hebrew")) {
			sendingMsg = "שולח בקשה";
		}

		mProgressDialog = Utils.showProgressDialog(sendingMsg, this);
	}

	public void showProgressDialogDynamic(String msg) {
		mProgressDialog = Utils.showProgressDialog(msg, this);
	}

	public void closeProgressDialog() {
		if (mProgressDialog != null)
			mProgressDialog.cancel();
	}

	public void showErrorToast() {
		Toast.makeText(this, stringPicker.getString("mlt_error_network"),
				Toast.LENGTH_SHORT).show();
	}

	public void updateProgressDialogMessage(Integer value) {
		mProgressDialog.setMessage(stringPicker
				.getString("mlt_req_sent_wait_for_user") + value);
	}

	public void showEmptyValueToast() {
		Toast.makeText(this, stringPicker.getString("mlt_enter_value"),
				Toast.LENGTH_SHORT).show();
	}

	public void showResendSuccessToast() {
		Toast.makeText(this, stringPicker.getString("mlt_wait_for_new_code"),
				Toast.LENGTH_SHORT).show();
	}

	public Dialog showDialog(String name, String category,
			final String phoneNumber) {

		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);

		// set title
		alertDialogBuilder.setTitle(name);

		// set dialog message
		alertDialogBuilder
				.setMessage(
						String.format(
								stringPicker.getString("people_find_text"),
								category))
				.setCancelable(false)
				.setNegativeButton(stringPicker.getString("mlt_call_him"),
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog, int id) {
								String uri = "tel:" + "+" + phoneNumber.trim();
								Intent intent = new Intent(Intent.ACTION_CALL);
								intent.setData(Uri.parse(uri));
								startActivity(intent);
							}
						})
				.setPositiveButton(stringPicker.getString("cancel"),
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog, int id) {
								// if this button is clicked, just close
								// the dialog box and do nothing
								dialog.cancel();
							}
						});

		// create alert dialog
		AlertDialog alertDialog = alertDialogBuilder.create();

		// show it
		alertDialog.show();
		return alertDialog;
	}

	@Override
	protected void onResume() {
		super.onResume();
		try {
			ViewProcessor.process(this, (ViewGroup) getWindow().getDecorView()
					.getRootView(), getLanguageFileName());
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		stringPicker = new StringPicker(this, getLanguageFileName());

		try {
			ViewProcessor.processActivityTitle(this, getLanguageFileName());
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	protected String getLanguageFileName() {
		String lang = getSharedPreferences("app_settings", Context.MODE_PRIVATE)
				.getString("lang", "English");
		if (lang.equalsIgnoreCase("hebrew"))
			return "hebrew.xml";

		return "english.xml";
	}

	protected boolean isHebrew() {
		String lang = getSharedPreferences("app_settings", Context.MODE_PRIVATE)
				.getString("lang", "English");
		return lang.equalsIgnoreCase("hebrew");
	}
}
