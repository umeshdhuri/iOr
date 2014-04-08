package com.ior.charityapp.invite;

import java.util.List;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.facebook.Request;
import com.facebook.Request.GraphUserListCallback;
import com.facebook.Response;
import com.facebook.Session;
import com.facebook.Session.OpenRequest;
import com.facebook.SessionLoginBehavior;
import com.facebook.SessionState;
import com.facebook.UiLifecycleHelper;
import com.facebook.model.GraphUser;
import com.ior.charityapp.lang.ViewProcessor;
import com.ior.charityappior.DialogActivity;
import com.ior.charityappior.R;

public class FacebookInviteActivity extends DialogActivity {

	public static final String TAG = "FBInviteActivity";
	public static final int REQUEST_CODE_FB_LOGIN = 1234;
	private FacebookFriendListAdapter adapter;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_list_friends);

		uiHelper = new UiLifecycleHelper(this, callback);
		uiHelper.onCreate(savedInstanceState);

		init();

		// now process language
		try {
			ViewProcessor.process(this, (ViewGroup) getWindow().getDecorView(),
					getLanguageFileName());
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	private void init() {
		ImageView icon = (ImageView) findViewById(R.id.img_icon);
		TextView title = (TextView) findViewById(R.id.txt_title);

		icon.setBackgroundResource(R.drawable.ic_facebook);
		title.setTag("mlt_my_fb_friends");

		adapter = new FacebookFriendListAdapter(this);
		ListView list = (ListView) findViewById(R.id.list);
		list.setAdapter(adapter);
	}

	private void onSessionStateChange(Session session, SessionState state,
			Exception exception) {
		if (state.isOpened()) {
			Log.i(TAG, "Logged in...");

			loadFriendList();
		} else if (state.isClosed()) {
			Log.i(TAG, "Logged out...");
		} else {
			Log.i(TAG, "unknown session state");
		}
	}

	private UiLifecycleHelper uiHelper;
	private Session.StatusCallback callback = new Session.StatusCallback() {
		@Override
		public void call(Session session, SessionState state,
				Exception exception) {
			onSessionStateChange(session, state, exception);
		}
	};

	protected void onStart() {
		super.onStart();

		// For scenarios where the main activity is launched and user
		// session is not null, the session state change notification
		// may not be triggered. Trigger it if it's open/closed.
		Session session = Session.getActiveSession();
		if (session == null) {
			session = new Session(this);
			Session.setActiveSession(session);
			openSession();
		} else {
			if (!session.isOpened() && !session.isClosed()
					&& session.getState() != SessionState.OPENING) {
				openSession();
			} else {
				Log.w(TAG, "Open active session");
				Session.openActiveSession(this, true, callback);
			}

			onSessionStateChange(session, session.getState(), null);
		}
	}

	@Override
	public void onResume() {
		super.onResume();
		uiHelper.onResume();
	}

	private void openSession() {
		OpenRequest openRequest = new OpenRequest(this);
		openRequest.setCallback(callback);
		openRequest.setPermissions("publish_stream", "read_friendlists",
				"user_friends");
		openRequest.setLoginBehavior(SessionLoginBehavior.SSO_WITH_FALLBACK);
		openRequest.setRequestCode(REQUEST_CODE_FB_LOGIN);
		Session.getActiveSession().openForPublish(openRequest);
		Log.i(TAG, "opening session for publish...");
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (requestCode == REQUEST_CODE_FB_LOGIN) {
			uiHelper.onActivityResult(requestCode, resultCode, data);
		}
		Session.getActiveSession().onActivityResult(this, requestCode,
				resultCode, data);
	}

	@Override
	public void onPause() {
		super.onPause();
		uiHelper.onPause();
	}

	@Override
	public void onDestroy() {
		super.onDestroy();
		uiHelper.onDestroy();
	}

	@Override
	public void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState);
		uiHelper.onSaveInstanceState(outState);
	}

	private void loadFriendList() {
		Request.newMyFriendsRequest(Session.getActiveSession(),
				graphUserListCallback).executeAsync();
	}

	private GraphUserListCallback graphUserListCallback = new GraphUserListCallback() {

		@Override
		public void onCompleted(List<GraphUser> users, Response response) {
			Log.d(TAG, "got friends list");
			adapter.clear();
			if (users != null && users.size() > 0) {
				for (GraphUser u : users) {
					adapter.add(u);
				}
			} else {
				Log.d(TAG, "friend list empty");
			}
			adapter.notifyDataSetChanged();
		}
	};

}
