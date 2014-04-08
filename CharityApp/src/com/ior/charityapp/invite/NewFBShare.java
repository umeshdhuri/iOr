package com.ior.charityapp.invite;

import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.Log;

import com.ior.charityappior.Request.OnInviteTextLoadListener;

public class NewFBShare extends FragmentActivity {

	private NewFBLogin mainFragment;
	public static String inviteText = "";

	@Override
	protected void onCreate(final Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		// 96cILaTzaIyCTYNSjZpM6yfVVdQ=
		// try {
		// PackageInfo info = getPackageManager().getPackageInfo(
		// "com.ior.charityappior", PackageManager.GET_SIGNATURES);
		// for (Signature signature : info.signatures) {
		// MessageDigest md = MessageDigest.getInstance("SHA");
		// md.update(signature.toByteArray());
		// String keyhash= Base64.encodeToString(md.digest(), Base64.DEFAULT);
		// Log.e("KeyHash:", keyhash);// g
		// Toast.makeText(getApplicationContext(), keyhash,
		// Toast.LENGTH_LONG).show();
		// }
		// } catch (NameNotFoundException e) {
		//
		// } catch (NoSuchAlgorithmException e) {
		//
		// }

		final ProgressDialog progressDialog = ProgressDialog.show(this, "iOr",
				"Please wait...");

		new AsyncTask<Object, Object, Object>() {

			@Override
			protected Object doInBackground(Object... params) {
				if (inviteText != null && inviteText.equals("")) {
					com.ior.charityappior.Request.getInviteText(
							NewFBShare.this, new OnInviteTextLoadListener() {

								@Override
								public void onLoadPhoneInviteText(String text) {
									// unused
								}

								@Override
								public void onLoadFacebookInviteText(String text) {
									inviteText = text;
								}

								@Override
								public void onLoadEmailInviteText(String text) {
									// unused
								}
							}, isHebrew());
				} else {
					inviteText = "";
				}

				Log.e("inviteText ", " inviteText  :" + inviteText);
				publishProgress();
				return null;
			}

			@Override
			protected void onProgressUpdate(Object... values) {
				// TODO Auto-generated method stub
				super.onProgressUpdate(values);
				progressDialog.dismiss();
				if (savedInstanceState == null) {
					// Add the fragment on initial activity setup
					mainFragment = new NewFBLogin();
					getSupportFragmentManager().beginTransaction()
							.add(android.R.id.content, mainFragment).commit();
				} else {
					// Or set the fragment from restored state info
					mainFragment = (NewFBLogin) getSupportFragmentManager()
							.findFragmentById(android.R.id.content);
				}
			}

			@Override
			protected void onPostExecute(Object result) {
				// TODO Auto-generated method stub
				super.onPostExecute(result);

			}
		}.execute();

	}

	protected boolean isHebrew() {
		String lang = getSharedPreferences("app_settings", Context.MODE_PRIVATE)
				.getString("lang", "English");
		return lang.equalsIgnoreCase("hebrew");
	}
}
