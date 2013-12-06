package com.ior.charityapp.lang;

import android.app.Activity;
import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

public class ViewProcessor {

	/**
	 * Updates text of TextView, EditText and hint of EditText in the given view
	 * group
	 * 
	 * @param context
	 * @param group
	 * @param languageFileName
	 */
	public static void process(Context context, ViewGroup group,
			String languageFileName) {
		StringPicker sp = new StringPicker(context, languageFileName);
		sp.process(group);

		if (languageFileName.toLowerCase().contains("hebrew")) {
			sp.rtl(group);
		} else {
			sp.ltr(group);
		}
	}

	/**
	 * Updates activity title
	 * 
	 * @param activity
	 * @param languageFileName
	 */
	public static void processActivityTitle(Activity activity,
			String languageFileName) {
		StringPicker sp = new StringPicker(activity, languageFileName);
		String title = sp.getString((String) activity.getTitle());
		if (title != null) {
			activity.setTitle(title);
		}
	}
	
}
