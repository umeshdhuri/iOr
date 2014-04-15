package com.ior.charityappior;

import static com.ior.charityappior.Utils.log;
import static java.lang.Thread.sleep;

import java.util.ArrayList;
import java.util.concurrent.atomic.AtomicInteger;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.AsyncTask;

import com.ior.charityapp.fragments.FragmentNeedHelpPeople;
import com.ior.charityapp.models.Category;
import com.ior.charityapp.models.Helper;
import com.ior.charityappior.ActivityNeedHelp.SearchPeopleTask;

public class SearchHelperListing extends DialogActivity {

	private static final int SEC = 1000;
	private static final int WAIT_TIME = 30;
	AtomicInteger msgId = new AtomicInteger();
	Category mSelectedCategory;
	AlertDialog mSearchPeopleDialog;
	AlertDialog mSendNotifDialog;
	
	class SearchPeopleTask extends AsyncTask<Void, Integer, Void> {
		ArrayList<Helper> people;
		int mMinRadius;
		int mMaxRadius;
		int mId;
		Context mContext;
		boolean mIsPushSearch;
		String mDescription;

		SearchPeopleTask(Context context, int minRadius, int maxRadius, int id,
				boolean isPushSearch, String description) {
			log("fds", "SearchPeopleTask");
			mMinRadius = minRadius;
			mMaxRadius = maxRadius;
			mId = id;
			mContext = context;
			mIsPushSearch = isPushSearch;
			mDescription = description;
		}

		@Override
		protected void onProgressUpdate(final Integer... values) {
			log("dfs", "onProgressUpdate");
			runOnUiThread(new Runnable() {
				@Override
				public void run() {
					updateProgressDialogMessage(values[0]);
				}
			});

		}

		@Override
		protected Void doInBackground(Void... params) {
			log("fds", "doInBackground");
			if (mIsPushSearch) {
				log("fds", "mIsPushSearch=true");
				String id = Request.sendMessage(SearchHelperListing.this,
						mMinRadius, mMaxRadius, mDescription, "0", "");
				if (id == null)
					return null;
				mId = Integer.valueOf(id);
				if (mId == 0) {
					people = new ArrayList<Helper>();
				} else {
					try {
						for (int i = WAIT_TIME; i > 0; i--) {
							onProgressUpdate(i);
							sleep(SEC);
						}
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
					people = Request.getRequestHelpers(mContext, mId);
					setSelectedCategory(new Category(-1, mDescription, "", ""));
				}
			} else {
				people = Request.getPeople(mContext, mMinRadius, mMaxRadius,
						mId);
			}
			return null;
		}

		@Override
		protected void onPostExecute(Void v) {
			closeProgressDialog();
			if (people != null) {
				if (people.size() == 0) {
					int newDistance = Utils.getNewDistance(mMaxRadius);
					if (newDistance != 1) {
						showSearchPeopleDialog(mMaxRadius, newDistance, mId,
								mIsPushSearch, mDescription);
					} else {
						showNoResultDialog();
					}
				} else {
					//setFragment(new FragmentNeedHelpPeople(mSelectedCategory, mMaxRadius, mDescription , people, Integer.toString(mId)));
				}
			} else {
				showErrorToast();
			}
		}
	}
	
	public AlertDialog showSearchPeopleDialog(final int oldDistance,
			final int newDistance, final int categoryId,
			final boolean isPushMessage, final String description) {
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);

		/*
		 * alertDialogBuilder.setTitle(getString(R.string.no_people_text,
		 * oldDistance));
		 */

		alertDialogBuilder.setTitle(String.format(
				stringPicker.getString("no_people_text"), oldDistance));
		/*
		 * alertDialogBuilder .setMessage( isPushMessage ? getString(
		 * R.string.search_to_push_range, newDistance) :
		 * getString(R.string.search_range_text, newDistance))
		 */
		alertDialogBuilder
				.setMessage(
						isPushMessage ? String.format(
								stringPicker.getString("search_to_push_range"),
								newDistance) : String.format(
								stringPicker.getString("search_range_text"),
								newDistance))
				.setCancelable(false)
				.setNegativeButton(stringPicker.getString("mlt_yes"),
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog, int id) {
								//mSearchPeopleTask = new SearchPeopleTask( ActivityNeedHelp.this, oldDistance, newDistance, categoryId, isPushMessage, description).execute();
								mSearchPeopleDialog.cancel();
								showProgressDialog();
							}
						})
				.setPositiveButton(stringPicker.getString("mlt_no"),
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog, int id) {
								dialog.cancel();
							}
						});

		AlertDialog alertDialog = alertDialogBuilder.create();

		alertDialog.show();
		mSearchPeopleDialog = alertDialog;
		return alertDialog;
	}
	
	public void setSelectedCategory(Category selectedCategory) {
		mSelectedCategory = selectedCategory;
	}

	private void showNoResultDialog() {
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
		alertDialogBuilder
				.setMessage(stringPicker.getString("no_results_text"))
				.setCancelable(true);
		AlertDialog alertDialog = alertDialogBuilder.create();
		alertDialog.show();
	}
}
