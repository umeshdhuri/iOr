package com.ior.charityappior;

import static com.ior.charityappior.Utils.log;
import static java.lang.Thread.sleep;

import java.util.ArrayList;
import java.util.concurrent.atomic.AtomicInteger;

import android.R.integer;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.ior.charityapp.fragments.FragmentNeedHelpPeople;
import com.ior.charityapp.fragments.NeedHelpCategoriesFragment;
import com.ior.charityapp.lang.ViewProcessor;
import com.ior.charityapp.models.Category;
import com.ior.charityapp.models.Helper;
import com.ior.charityappior.R;

/**
 * Created by android-dev on 27.08.13.
 */
public class ActivityNeedHelp extends DialogActivity {

	private static final int SEC = 1000;
	private static final int WAIT_TIME = 30;
	AtomicInteger msgId = new AtomicInteger();

	Category mSelectedCategory;
	AlertDialog mSearchPeopleDialog;
	AlertDialog mSendNotifDialog;
	AsyncTask<Void, Integer, Void> mSearchPeopleTask;
	private ArrayList<Category> categories = new ArrayList<Category>();

	public void setSelectedCategory(Category selectedCategory) {
		mSelectedCategory = selectedCategory;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.fragment_holder);

		// show title
		setTitle(stringPicker.getString("mlt_title_need_help"));

		setFragment(new NeedHelpCategoriesFragment());
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
								mSearchPeopleTask = new SearchPeopleTask(
										ActivityNeedHelp.this, oldDistance,
										newDistance, categoryId, isPushMessage,
										description).execute();
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

	public void showCreateNotificationDialog() {
		AlertDialog.Builder builder;

		LayoutInflater inflater = (LayoutInflater) getSystemService(LAYOUT_INFLATER_SERVICE);
		View layout = inflater.inflate(R.layout.dialog_create_notification,
				(ViewGroup) findViewById(R.id.layout_root));
		try {
			ViewProcessor.process(this, (ViewGroup) layout,
					getLanguageFileName());
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		builder = new AlertDialog.Builder(this);
		builder.setView(layout);
		builder.setCancelable(true);

		final EditText etDescription = (EditText) layout
				.findViewById(R.id.etNotif);

		Button btNegative = (Button) layout.findViewById(R.id.btCancel);
		// if button is clicked, close the custom dialog
		btNegative.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				mSendNotifDialog.dismiss();
				log("XXX", "onClick cancel");
			}
		});
		Button btPositive = (Button) layout.findViewById(R.id.btSend);
		// if button is clicked, close the custom dialog
		btPositive.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				final String description = etDescription.getText().toString();
				if (description.isEmpty()) {
					Toast.makeText(ActivityNeedHelp.this,
							stringPicker.getString("empty_description_error"),
							Toast.LENGTH_SHORT).show();
				} else {
					mSearchPeopleTask = new SearchPeopleTask(
							ActivityNeedHelp.this, 0, 1, 0, true, description)
							.execute();
					mSendNotifDialog.dismiss();
					showProgressDialog();
				}
				log("XXX", "onClick send");
			}
		});

		builder.create();
		mSendNotifDialog = builder.show();
	}

	public ArrayList<Category> getCategories() {
		return categories;
	}

	public void setCategories(ArrayList<Category> categories) {
		this.categories = categories;
	}

	
	public void searchPeopel(final int oldDist, final int newDist, final int catId, final String message) {
		
		mSearchPeopleTask = new SearchPeopleTask(
				ActivityNeedHelp.this, oldDist, newDist, 0, true,  message)
				.execute();
		mSendNotifDialog.dismiss();
		showProgressDialog();
		
	}
	
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
				String id = Request.sendMessage(ActivityNeedHelp.this,
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
					setSelectedCategory(new Category(-1, mDescription, ""));
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
					setFragment(new FragmentNeedHelpPeople(mSelectedCategory, mMaxRadius, mDescription
							, people, Integer.toString(mId)));
				}
			} else {
				showErrorToast();
			}
		}
	}

	private void showNoResultDialog() {
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
		alertDialogBuilder
				.setMessage(stringPicker.getString("no_results_text"))
				.setCancelable(true);
		AlertDialog alertDialog = alertDialogBuilder.create();
		alertDialog.show();
	}

	@Override
	protected void onStop() {
		super.onStop();
		if (mSearchPeopleTask != null
				&& mSearchPeopleTask.getStatus() == AsyncTask.Status.RUNNING) {
			mSearchPeopleTask.cancel(true);
			closeProgressDialog();
		}
	}
}
