package com.ior.charityapp.fragments;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.ViewGroup;

import com.ior.charityapp.lang.StringPicker;
import com.ior.charityapp.lang.ViewProcessor;

@SuppressLint("NewApi")
public class ParentFragment extends Fragment {

	protected StringPicker stringPicker;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		stringPicker = new StringPicker(getActivity(), getLanguageFileName());
	}

	@Override
	public void onResume() {
		super.onResume();

		try {
			ViewProcessor.process(getActivity(), (ViewGroup) getActivity()
					.getWindow().getDecorView().getRootView(),
					getLanguageFileName());
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	protected String getLanguageFileName() {
		String lang = getActivity().getSharedPreferences("app_settings",
				Context.MODE_PRIVATE).getString("lang", "English");
		if (lang.equalsIgnoreCase("hebrew"))
			return "hebrew.xml";

		return "english.xml";
	}

	protected boolean isHebrew() {
		String lang = getActivity().getSharedPreferences("app_settings",
				Context.MODE_PRIVATE).getString("lang", "English");
		if (lang.equalsIgnoreCase("hebrew"))
			return true;

		return false;
	}
}
