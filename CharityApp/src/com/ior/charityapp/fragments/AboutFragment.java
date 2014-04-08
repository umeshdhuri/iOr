package com.ior.charityapp.fragments;

/**
 * Created by android-dev on 09.09.13.
 */

import static com.ior.charityappior.Utils.log;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.Spannable;
import android.text.SpannableString;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.facebook.FacebookException;
import com.facebook.FacebookOperationCanceledException;
import com.facebook.Session;
import com.facebook.SessionLoginBehavior;
import com.facebook.Session.OpenRequest;
import com.facebook.SessionState;
import com.facebook.UiLifecycleHelper;
import com.facebook.widget.FacebookDialog;
import com.facebook.widget.FacebookDialog.ShareDialogBuilder;
import com.facebook.widget.WebDialog;
import com.facebook.widget.WebDialog.OnCompleteListener;
import com.google.android.gms.plus.PlusShare;
import com.ior.charityapp.invite.DeviceEmailListActivity;
import com.ior.charityapp.invite.PhoneFriendListActivity;
import com.ior.charityapp.lang.StringPicker;
import com.ior.charityapp.lang.ViewProcessor;
import com.ior.charityappior.ActivityMain;
import com.ior.charityappior.R;
import com.ior.charityappior.Request;
import com.ior.charityappior.Request.OnInviteTextLoadListener;

public class AboutFragment extends ParentFragment implements OnClickListener {

	public static final String TAG = "AboutFragment";
	private static final String ARG_POSITION = "position";

	private int position;
	private StringPicker stringPicker;

	private String[] strings_about;
	Button changeLagnBtn;
	TextView tvText;
	LinearLayout languageLayout;
	private RadioButton radioLangButton, radioEngBtn, radioHeBtn;
	private RadioGroup radioLangGroup;
	private View root;
	private View inviteLayout;
	String tempLang, langVal;
	String languageResponse;
	private ProgressDialog progressDialog;
	int selectedRadioBtn;
	private String fbInviteText = "invite on Facebook";

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
		// strings_about = new String[] { stringPicker.getString("description"),
		// stringPicker.getString("concept"),
		// "Change Language Text",
		// stringPicker.getString("mlt_invite_friends")
		// };
		/*
		 * strings_about = new String[] {
		 * stringPicker.getString("mlt_description"),
		 * stringPicker.getString("mlt_concept"),
		 * stringPicker.getString("mlt_change_language"),
		 * stringPicker.getString("mlt_invite_friends") };
		 */
		strings_about = new String[] { stringPicker.getString("description"),
				stringPicker.getString("concept"), "Change Language Text",
				stringPicker.getString("mlt_invite_friends") };

		position = getArguments().getInt(ARG_POSITION);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {

		// Facebook fallback to Feed Dialog
		if (savedInstanceState != null) {
			pendingPublishReauthorization = savedInstanceState.getBoolean(
					PENDING_PUBLISH_KEY, false);
		}

		root = inflater.inflate(R.layout.fragment_about, container, false);
		tvText = (TextView) root.findViewById(R.id.tvAbout);
		languageLayout = (LinearLayout) root
				.findViewById(R.id.changePassLayout);
		changeLagnBtn = (Button) root.findViewById(R.id.btnDisplay);
		radioLangGroup = (RadioGroup) root.findViewById(R.id.radioLanguage);
		radioEngBtn = (RadioButton) root.findViewById(R.id.radioEnglish);
		radioHeBtn = (RadioButton) root.findViewById(R.id.radioHebrew);
		inviteLayout = root.findViewById(R.id.layout_invite);

		if (getActivity()
				.getSharedPreferences("app_settings", Context.MODE_PRIVATE)
				.getString("lang", "").equalsIgnoreCase("English")) {
			radioLangGroup.check(radioEngBtn.getId());
			changeLagnBtn.setText("Change Language");
		} else if (getActivity()
				.getSharedPreferences("app_settings", Context.MODE_PRIVATE)
				.getString("lang", "").equalsIgnoreCase("Hebrew")) {
			radioLangGroup.check(radioHeBtn.getId());
			changeLagnBtn.setText("החלף שפה");
		}

		languageLayout.setVisibility(View.GONE);
		log("About View", "position === " + position);
		String descText = strings_about[position];
		Spannable spanText = new SpannableString(strings_about[position]);
		log("About View", "spanText === " + descText);

		// "Change Language Text"
		// final String changeLang =
		// stringPicker.getString("mlt_change_language");
		// if (descText.equalsIgnoreCase(changeLang)) {
		if (descText.equalsIgnoreCase("Change Language Text")) {
			tvText.setVisibility(View.GONE);
			languageLayout.setVisibility(View.VISIBLE);

			changeLagnBtn.setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View arg0) {
					// get selected radio button from radioGroup
					int selectedId = radioLangGroup.getCheckedRadioButtonId();

					// find the radio button by returned id
					radioLangButton = (RadioButton) root
							.findViewById(selectedId);
					langVal = (String) radioLangButton.getTag();
					if (langVal.length() > 0) {

						if (langVal.equalsIgnoreCase("0")) {
							tempLang = "English";
							progressDialog = ProgressDialog.show(getActivity(),
									"", "Sending request");
						} else {
							tempLang = "Hebrew";
							progressDialog = ProgressDialog.show(getActivity(),
									"", "שולח בקשה");
						}
						progressDialog.show();
						new changeLanguage().execute();
					}

				}

			});

		} else if (position == 3) {
			inviteLayout.setVisibility(View.VISIBLE);

			View fb = inviteLayout.findViewById(R.id.vg_fb);
			View phone = inviteLayout.findViewById(R.id.vg_phone);
			// View plus = inviteLayout.findViewById(R.id.vg_plus);
			View gmail = inviteLayout.findViewById(R.id.vg_gmail);

			fb.setOnClickListener(this);
			phone.setOnClickListener(this);
			// plus.setOnClickListener(this);
			gmail.setOnClickListener(this);

		} else {
			changeLagnBtn.setVisibility(View.GONE);
			tvText.setText(spanText);
		}

		// apply language
		viewProcessor();

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

			// ((ActivityMain) getActivity()).closeProgressDialog();
			if (languageResponse == null) {

				if (progressDialog.isShowing()) {
					progressDialog.dismiss();
				}

			} else {

				if (progressDialog.isShowing()) {
					progressDialog.dismiss();
				}

				getActivity()
						.getSharedPreferences("app_settings",
								Context.MODE_PRIVATE).edit()
						.putString("lang", tempLang).commit();

				viewProcessor();

				Intent intent = new Intent(getActivity(), ActivityMain.class);
				intent.putExtra("ChangeLanguage", true);
				startActivity(intent);

			}
		}

	}

	private void viewProcessor() {
		try {
			ViewProcessor.process(getActivity(), (ViewGroup) getActivity()
					.getWindow().getDecorView().getRootView(),
					getLanguageFileName());
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	private void changeLanguageSync() {

		String passLang = "";
		if (tempLang.equalsIgnoreCase("English")) {
			passLang = "";
		} else {
			passLang = "he";
		}

		// log("Token Key", getActivity().getSharedPreferences("app_settings",
		// Context.MODE_PRIVATE).getString("TOKEN_KEY", null));
		// String TokenValue =
		// getActivity().getSharedPreferences("app_settings",
		// Context.MODE_PRIVATE).getString("TOKEN_KEY", null);

		languageResponse = Request.updateLanguage(getActivity(), passLang);
	}

	/* invitation panel logic */

	private UiLifecycleHelper uiHelper;
	private Session.StatusCallback callback = new Session.StatusCallback() {
		@Override
		public void call(Session session, SessionState state,
				Exception exception) {
			if (exception != null) {
				exception.printStackTrace();
			} else {
				onStateChanged();
			}
		}
	};

	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		uiHelper = new UiLifecycleHelper(getActivity(), callback);
		uiHelper.onCreate(savedInstanceState);
	}

	@Override
	public void onStart() {
		super.onStart();

		Thread th = new Thread() {
			public void run() {
				try {
					Request.getInviteText(getActivity(),
							new OnInviteTextLoadListener() {

								@Override
								public void onLoadPhoneInviteText(String text) {
									// unused
								}

								@Override
								public void onLoadFacebookInviteText(String text) {
									fbInviteText = text;
								}

								@Override
								public void onLoadEmailInviteText(String text) {
									// unused
								}
							}, isHebrew());
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
		};
		th.start();
	}

	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.vg_fb) {
			post();

			// Intent i = new Intent(getActivity(), NewFBShare.class);
			// i.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
			// startActivity(i);
		} else if (v.getId() == R.id.vg_phone) {
			Intent i = new Intent(getActivity(), PhoneFriendListActivity.class);
			i.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
			startActivity(i);
			/*
			 * } else if (v.getId() == R.id.vg_plus) { plus();
			 */
		} else if (v.getId() == R.id.vg_gmail) {
			Intent i = new Intent(getActivity(), DeviceEmailListActivity.class);
			i.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
			startActivity(i);
		}
	}

	private void plus() {
		// Launch the Google+ share dialog with attribution to your app.
		Intent shareIntent = new PlusShare.Builder(getActivity())
				.setType("text/plain")
				.setText("iOr")
				.setContentUrl(
						Uri.parse("https://play.google.com/store/apps/details?id="
								+ getActivity().getPackageName())).getIntent();

		startActivityForResult(shareIntent, 0);
	}

	private void post() {
		// final String picture =
		// "http://ior.applistore.mobi/images/logoImage.png";
		final String caption = "ior.applistore.mobi";
		final String picture = "http://ior.applistore.mobi/images/logoImage1.png";
		final String appName = "iOr";
		final String link = "https://play.google.com/store/apps/details?id="
				+ getActivity().getPackageName();

		if (FacebookDialog.canPresentShareDialog(getActivity(),
				FacebookDialog.ShareDialogFeature.SHARE_DIALOG)) {
			// Publish the post using the Share Dialog
			ShareDialogBuilder builder = new ShareDialogBuilder(getActivity());
			builder.setApplicationName(appName);
			builder.setName(appName);
			builder.setCaption(caption);
			builder.setLink(link);
			builder.setPicture(picture);
			builder.setDescription(fbInviteText);
			FacebookDialog dialog = builder.build();

			uiHelper.trackPendingDialogCall(dialog.present());
		} else {
			Session session = Session.getActiveSession();
			if (session == null
					|| session.getState().equals(
							SessionState.CLOSED_LOGIN_FAILED)) {
				session = Session.openActiveSession(getActivity(), this, true,
						callback);
				Session.setActiveSession(session);
			}

			// Check for publish permissions
			List<String> permissions = session.getPermissions();
			if (!isSubsetOf(PERMISSIONS, permissions)) {
				// mark as pending
				pendingPublishReauthorization = true;

				if (!session.getState().equals(
						SessionState.OPENED_TOKEN_UPDATED)
						&& !session.getState().equals(SessionState.OPENED)) {
					// open session
					OpenRequest openRequest = new OpenRequest(this);
					openRequest
							.setLoginBehavior(SessionLoginBehavior.SSO_WITH_FALLBACK);
					openRequest.setCallback(callback);
					openRequest.setPermissions(PERMISSIONS);
					try {
						session.openForPublish(openRequest);
						return;
					} catch (UnsupportedOperationException ex) {
						ex.printStackTrace();
					}
				}

				Session.NewPermissionsRequest newPermissionsRequest = new Session.NewPermissionsRequest(
						this, PERMISSIONS);
				try {
					session.requestNewPublishPermissions(newPermissionsRequest);
					return;
				} catch (UnsupportedOperationException ex) {
					ex.printStackTrace();
				}
			}

			if (pendingPublishReauthorization
					&& session.getState().equals(SessionState.OPENED)) {
				pendingPublishReauthorization = false;
			}

			log(TAG, "session state=" + session.getState());

			// Fallback. For example, publish the post using the Feed Dialog
			publishFeedDialog(session, appName, caption, fbInviteText, link,
					picture);
		}
	}

	private void publishFeedDialog(Session session, String name,
			String caption, String desc, String link, String pictureLink) {

		if (session == null || !session.getState().equals(SessionState.OPENED)) {
			Log.e(TAG, "publish failed, FB session not opened");
			return;
		}

		Bundle params = new Bundle();
		params.putString("name", name);
		params.putString("caption", caption);
		params.putString("description", desc);
		params.putString("link", link);
		params.putString("picture", pictureLink);

		WebDialog feedDialog = (new WebDialog.FeedDialogBuilder(getActivity(),
				session, params)).setOnCompleteListener(
				new OnCompleteListener() {

					@Override
					public void onComplete(Bundle values,
							FacebookException error) {
						// if (values != null) {
						// for (String key : values.keySet()) {
						// Log.d(TAG, key + "=" + values.get(key));
						// }
						// }

						if (error == null) {
							// When the story is posted, echo the success
							// and the post Id.
							final String postId = values.getString("post_id");
							if (postId != null) {
								Toast.makeText(getActivity(),
										"Posted story, id: " + postId,
										Toast.LENGTH_SHORT).show();
							} else {
								// User clicked the Cancel button
								Toast.makeText(
										getActivity().getApplicationContext(),
										"Publish cancelled", Toast.LENGTH_SHORT)
										.show();
							}
						} else if (error instanceof FacebookOperationCanceledException) {
							// User clicked the "x" button
							Toast.makeText(
									getActivity().getApplicationContext(),
									"Publish cancelled", Toast.LENGTH_SHORT)
									.show();
						} else {
							// Generic, ex: network error
							Toast.makeText(
									getActivity().getApplicationContext(),
									"Error posting story", Toast.LENGTH_SHORT)
									.show();
						}
					}

				}).build();
		feedDialog.setOwnerActivity(getActivity());
		feedDialog.show();
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);

		uiHelper.onActivityResult(requestCode, resultCode, data,
				new FacebookDialog.Callback() {
					@Override
					public void onError(FacebookDialog.PendingCall pendingCall,
							Exception error, Bundle data) {
						Log.e("Activity",
								String.format("Error: %s", error.toString()));
						toast(error.getMessage());
					}

					@Override
					public void onComplete(
							FacebookDialog.PendingCall pendingCall, Bundle data) {
						Log.i("Activity", "Success!");
					}
				});

		onStateChanged();
	}

	private void onStateChanged() {
		if (pendingPublishReauthorization
				&& Session.getActiveSession() != null
				&& Session.getActiveSession().getState()
						.equals(SessionState.OPENED)) {
			pendingPublishReauthorization = false;
			post();
		}
	}

	@Override
	public void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState);
		if (outState != null) {
			outState.putBoolean(PENDING_PUBLISH_KEY,
					pendingPublishReauthorization);

			if (uiHelper != null) {
				uiHelper.onSaveInstanceState(outState);
			}
		}
	}

	@Override
	public void onResume() {
		super.onResume();
		uiHelper.onResume();
	}

	@Override
	public void onPause() {
		super.onPause();
		uiHelper.onPause();
	}

	@Override
	public void onDestroy() {
		super.onDestroy();
		if (uiHelper != null) {
			uiHelper.onDestroy();
		}
	}

	// Facebook publish - fallback to Feed (old) Dialog

	private boolean isSubsetOf(Collection<String> subset,
			Collection<String> superset) {
		for (String string : subset) {
			if (!superset.contains(string)) {
				return false;
			}
		}
		return true;
	}

	private static final List<String> PERMISSIONS = Arrays.asList("basic_info",
			"publish_actions", "publish_stream");
	private static final String PENDING_PUBLISH_KEY = "pendingPublishReauthorization";
	private boolean pendingPublishReauthorization = false;

	private void toast(String text) {
		Toast.makeText(getActivity().getApplicationContext(), text,
				Toast.LENGTH_LONG).show();
	}
}
