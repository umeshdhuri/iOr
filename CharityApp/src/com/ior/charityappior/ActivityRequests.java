package com.ior.charityappior;

import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;

import com.ior.charityapp.fragments.FragmentMyRequests;
import com.ior.charityapp.models.UserRequest;
import com.ior.charityappior.R;

import java.util.ArrayList;

import static com.ior.charityappior.Utils.log;

/**
 * Created by android-dev on 11.09.13.
 */
public class ActivityRequests extends DialogActivity {
	public void setRequests(ArrayList<UserRequest> mRequests) {
		this.mRequests = mRequests;
	}

	public ArrayList<UserRequest> getRequests() {
		return mRequests;
	}

	ArrayList<UserRequest> mRequests = new ArrayList<UserRequest>();

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.fragment_holder);

		// show title
		setTitle(stringPicker.getString("mlt_title_requests"));

		showProgressDialog();
		new AsyncTask<Void, Void, ArrayList<UserRequest>>() {

			@Override
			protected ArrayList<UserRequest> doInBackground(Void... params) {
				return mRequests = Request.myRequests(ActivityRequests.this);
			}

			@Override
			protected void onPostExecute(ArrayList<UserRequest> result) {
				closeProgressDialog();
				if (mRequests == null) {
					showErrorToast();
				} else {
					setFragment(new FragmentMyRequests(mRequests));
				}
			}
		}.execute();
	}

	public void setFragment(Fragment fragment) {
		FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
		ft.setCustomAnimations(android.R.anim.slide_in_left,
				android.R.anim.slide_out_right, android.R.anim.fade_in,
				android.R.anim.fade_out);
		ft.replace(R.id.fragment, fragment);
		log("XXX", "fragment name " + fragment.getClass().getSimpleName());
		if (fragment.getClass().getSimpleName()
				.equals("FragmentNeedHelpPeople"))
			ft.addToBackStack(fragment.getClass().getName());
		ft.commit();
	}
}
