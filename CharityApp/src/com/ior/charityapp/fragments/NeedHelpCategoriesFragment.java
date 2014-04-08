package com.ior.charityapp.fragments;

import java.util.ArrayList;

import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;

import com.ior.charityapp.models.Category;
import com.ior.charityapp.models.Helper;
import com.ior.charityappior.ActivityNeedHelp;
import com.ior.charityappior.Request;
import com.ior.charityappior.R;

/**
 * Created by android-dev on 27.08.13.
 */
public class NeedHelpCategoriesFragment extends ParentFragment {
	ArrayList<Category> categories = new ArrayList<Category>();

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		final View root = inflater.inflate(
				R.layout.fragment_need_help_categories, container, false);
		categories = ((ActivityNeedHelp) getActivity()).getCategories();
		if (categories.size() != 0) {
			setupView(root);
			return root;
		}

		((ActivityNeedHelp) getActivity()).showProgressDialog();
		new AsyncTask<Void, Void, ArrayList<Category>>() {

			@Override
			protected ArrayList<Category> doInBackground(Void... params) {
				return categories = Request.getCategories(getActivity());
			}

			@Override
			protected void onPostExecute(ArrayList<Category> strings) {

				((ActivityNeedHelp) getActivity()).closeProgressDialog();
				if (categories == null) {
					((ActivityNeedHelp) getActivity()).showErrorToast();
				} else {
					((ActivityNeedHelp) getActivity())
							.setCategories(categories);
					setupView(root);
				}
			}
		}.execute();
		return root;

	}

	private void setupView(View root) {
		ListView lvCategories = (ListView) root.findViewById(R.id.lvCategories);
		ArrayList<String> categoryNames = new ArrayList<String>();
		for (Category category : categories) {
			categoryNames.add(category.mName);
		}
		if(isHebrew()) {
			lvCategories.setAdapter(new ArrayAdapter<String>(getActivity(),
					R.layout.people_list_item_hebrew, R.id.tvName, categoryNames));
		} else {
			lvCategories.setAdapter(new ArrayAdapter<String>(getActivity(),
					R.layout.people_list_item, R.id.tvName, categoryNames));
		}

		lvCategories
				.setOnItemClickListener(new AdapterView.OnItemClickListener() {
					@Override
					public void onItemClick(AdapterView<?> parent, View view,
							final int position, long id) {

						((ActivityNeedHelp) getActivity())
								.setSelectedCategory(categories.get(position));
						final int distance = 1;

						((ActivityNeedHelp) getActivity()).showProgressDialog();
						new AsyncTask<Void, Void, ArrayList<Helper>>() {

							@Override
							protected ArrayList<Helper> doInBackground(
									Void... params) {
								return Request.getPeople(getActivity(), 0,
										distance,
										categories.get(position).mCategoryId);
							}

							@Override
							protected void onPostExecute(
									ArrayList<Helper> result) {
								((ActivityNeedHelp) getActivity())
										.closeProgressDialog();
								if (result == null) {
									((ActivityNeedHelp) getActivity())
											.showErrorToast();
								} else {
									if (result.size() == 0) {
										int newDistance = 5;
										((ActivityNeedHelp) getActivity())
												.showSearchPeopleDialog(
														distance,
														newDistance,
														categories
																.get(position).mCategoryId,
														false, null);
									} else {
										((ActivityNeedHelp) getActivity())
												.setFragment(new FragmentNeedHelpPeople(
														categories
																.get(position),
														result));
									}
								}
							}
						}.execute();
					}
				});

		Button btCustomCategory = (Button) root
				.findViewById(R.id.btCustomCategory);
		btCustomCategory.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				handleCustomCategoryClick();
			}
		});

	}

	private void handleCustomCategoryClick() {
		((ActivityNeedHelp) getActivity()).showCreateNotificationDialog();
	}
}
