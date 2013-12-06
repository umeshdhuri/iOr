package com.ior.charityapp.lang;

import android.content.Context;
import android.view.Menu;
import android.view.MenuItem;

public class MenuProcessor {

	/**
	 * Updates menu titles for all the menu items in given menu
	 * 
	 * @param context
	 * @param menu
	 * @param languageFileName
	 */
	public static void process(Context context, Menu menu,
			String languageFileName) {
		StringPicker sp = new StringPicker(context, languageFileName);
		for (int i = 0; i < menu.size(); i++) {
			MenuItem mi = menu.getItem(i);
			String key = (String) mi.getTitle();
			mi.setTitle(sp.getString(key));
		}
	}
}
