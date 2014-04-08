package com.ior.charityappior;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.util.Log;
import android.view.Window;

/**
 * Created by android-dev on 27.08.13.
 */
public class Utils {

	private static final String PREFS_NAME = "default prefs";
	private static final String TOKEN_KEY = "token";
	private static final boolean DEBUG = true;
	public static final boolean TEST = false;

	public static String getToken(Context context) {
		SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME,
				Context.MODE_PRIVATE);
		return prefs.getString(TOKEN_KEY, null);
	}

	public static void saveToken(Context context, String token) {
		SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME,
				Context.MODE_PRIVATE);
		prefs.edit().putString(TOKEN_KEY, token).commit();
	}

	public static void log(String tag, String message) {
		if (DEBUG) {
			if (tag.equals("draw points"))
				return;
			if (tag.equals("diagram cache")) {
				// logToFile(message,"cacheLog");
			}
			Log.v(tag, message);
		}
	}

	public static ProgressDialog showProgressDialog(String message,
			final Activity activity) {
		// lockOrientation(activity);
		ProgressDialog progressDialog = new ProgressDialog(activity);
		progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		progressDialog.setMessage(message);
		progressDialog.setCancelable(false);
		//
		progressDialog
				.setOnCancelListener(new DialogInterface.OnCancelListener() {
					@Override
					public void onCancel(DialogInterface dialog) {
						// activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED);
					}
				});
		try {
			progressDialog.show();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return progressDialog;
	}

	/*
	 * public static void lockOrientation(Activity activity) { switch
	 * (activity.getResources().getConfiguration().orientation) { case
	 * Configuration.ORIENTATION_PORTRAIT: if (android.os.Build.VERSION.SDK_INT
	 * < android.os.Build.VERSION_CODES.FROYO) {
	 * activity.setRequestedOrientation
	 * (ActivityInfo.SCREEN_ORIENTATION_PORTRAIT); } else { int rotation =
	 * activity.getWindowManager().getDefaultDisplay().getRotation(); if
	 * (rotation == android.view.Surface.ROTATION_90 || rotation ==
	 * android.view.Surface.ROTATION_180) {
	 * activity.setRequestedOrientation(ActivityInfo
	 * .SCREEN_ORIENTATION_REVERSE_PORTRAIT); } else {
	 * activity.setRequestedOrientation
	 * (ActivityInfo.SCREEN_ORIENTATION_PORTRAIT); } } break;
	 * 
	 * case Configuration.ORIENTATION_LANDSCAPE: if
	 * (android.os.Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.FROYO)
	 * {
	 * activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
	 * ); } else { int rotation =
	 * activity.getWindowManager().getDefaultDisplay().getRotation(); if
	 * (rotation == android.view.Surface.ROTATION_0 || rotation ==
	 * android.view.Surface.ROTATION_90) {
	 * activity.setRequestedOrientation(ActivityInfo
	 * .SCREEN_ORIENTATION_LANDSCAPE); } else {
	 * activity.setRequestedOrientation(
	 * ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE); } } break; } }
	 */

	public static int getNewDistance(int oldDistance) {
		switch (oldDistance) {
		case 1:
			return 5;
		case 5:
			return 10;
		case 10:
			return 50;
		case 50:
			return 100;
		default:
			return 1;
		}
	}
}
