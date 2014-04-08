package com.ior.charityapp.invite;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.facebook.FacebookRequestError;
import com.facebook.HttpMethod;
import com.facebook.Request;
import com.facebook.RequestAsyncTask;
import com.facebook.Response;
import com.facebook.Session;
import com.facebook.SessionState;
import com.facebook.UiLifecycleHelper;
import com.facebook.widget.LoginButton;
import com.ior.charityappior.R;

public class NewFBLogin extends Fragment {

	private UiLifecycleHelper uiHelper;
	private static final String TAG = "NewFBShare";
	//	private Button shareButton;

	private Session.StatusCallback callback = new Session.StatusCallback() {
		@Override
		public void call(Session session, SessionState state, Exception exception) {
			onSessionStateChange(session, state, exception);
		}
	};

	private void onSessionStateChange(Session session, SessionState state, Exception exception) {
		if (state.isOpened()) {
			//			shareButton.setVisibility(View.VISIBLE);
			if (pendingPublishReauthorization &&  state.equals(SessionState.OPENED_TOKEN_UPDATED)) {
				pendingPublishReauthorization = false;
//				publishStory();
			}else {
				publishStory();
			}
		} else if (state.isClosed()) {
			//			shareButton.setVisibility(View.INVISIBLE);
		}
	}
	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		uiHelper = new UiLifecycleHelper(getActivity(), callback);
		uiHelper.onCreate(savedInstanceState);


	}

	@Override
	public View onCreateView(LayoutInflater inflater, 
			ViewGroup container, 
			Bundle savedInstanceState) {

		if (savedInstanceState != null) {
			pendingPublishReauthorization = 
					savedInstanceState.getBoolean(PENDING_PUBLISH_KEY, false);
		}

		View view = inflater.inflate(R.layout.newfbloginlayout, container, false);

		LoginButton authButton = (LoginButton) view.findViewById(R.id.authButton);
		authButton.setFragment(this);

		/*shareButton = (Button) view.findViewById(R.id.shareButton);

		shareButton.setOnClickListener(new View.OnClickListener() {
		    @Override
		    public void onClick(View v) {
		        publishStory();        
		    }
		});*/

		return view;
	}

	@Override
	public void onResume() {
		super.onResume();
		// For scenarios where the main activity is launched and user
		// session is not null, the session state change notification
		// may not be triggered. Trigger it if it's open/closed.
//		Session session = Session.getActiveSession();
//		if (session != null &&(session.isOpened() || session.isClosed()) ) {
//			onSessionStateChange(session, session.getState(), null);
//		}

		uiHelper.onResume();
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		uiHelper.onActivityResult(requestCode, resultCode, data);
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
		outState.putBoolean(PENDING_PUBLISH_KEY, pendingPublishReauthorization);
		uiHelper.onSaveInstanceState(outState);
	}

	private static final List<String> PERMISSIONS = Arrays.asList("publish_actions");
	private static final String PENDING_PUBLISH_KEY = "pendingPublishReauthorization";
	private boolean pendingPublishReauthorization = false;

	private void publishStory() {
		Session session = Session.getActiveSession();

		if (session != null){

			// Check for publish permissions    
			List<String> permissions = session.getPermissions();
			if (!isSubsetOf(PERMISSIONS, permissions)) {
				pendingPublishReauthorization = true;
				Session.NewPermissionsRequest newPermissionsRequest = new Session
						.NewPermissionsRequest(this, PERMISSIONS);
				session.requestNewPublishPermissions(newPermissionsRequest);
				return;
			}

			final ProgressDialog progressDialog = ProgressDialog.show(getActivity(), "Facebook", "Sharing..."); 

			Bundle postParams = new Bundle();
			postParams.putString("name", "iOr");
//			postParams.putString("caption", "Build great social apps and get more installs.");
			postParams.putString("description", NewFBShare.inviteText);
			postParams.putString("link", "https://play.google.com/store/apps/details?id="+ getActivity().getPackageName());
//			postParams.putString("picture", "https://raw.github.com/fbsamples/ios-3.x-howtos/master/Images/iossdk_logo.png");

			Request.Callback callback= new Request.Callback() {
				public void onCompleted(Response response) {
					JSONObject graphResponse = response
							.getGraphObject()
							.getInnerJSONObject();
					String postId = null;
					try {
						postId = graphResponse.getString("id");
					} catch (JSONException e) {
						Log.i(TAG,
								"JSON error "+ e.getMessage());
					}
					FacebookRequestError error = response.getError();
					if (error != null) {
						Toast.makeText(getActivity().getApplicationContext(),error.getErrorMessage(),Toast.LENGTH_SHORT).show();
					} else {
						Toast.makeText(getActivity().getApplicationContext(),"Post Succesfully",Toast.LENGTH_LONG).show();
					}
					progressDialog.dismiss();
					getActivity().finish();
				}
			};

			Request request = new Request(session, "me/feed", postParams, HttpMethod.POST, callback);

			RequestAsyncTask task = new RequestAsyncTask(request);
			task.execute();
		}

	}

	private boolean isSubsetOf(Collection<String> subset, Collection<String> superset) {
		for (String string : subset) {
			if (!superset.contains(string)) {
				return false;
			}
		}
		return true;
	}


}
