package com.ior.charityapp.lang;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;

import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

import android.annotation.SuppressLint;
import android.content.Context;
import android.util.Log;
import android.util.Xml;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

public class StringPicker {

	public static final String TAG = "StringPicker";
	private Context context;
	private String languageFileName;
	private HashMap<String, String> strings = new HashMap<String, String>();

	public StringPicker(Context c, String langFileName) {
		this.context = c;
		this.languageFileName = langFileName;

		prepare();
	}

	private void prepare() {
		try {
			InputStream in = context.getAssets().open(
					"lang/" + languageFileName);

			XmlPullParser parser = Xml.newPullParser();
			parser.setFeature(XmlPullParser.FEATURE_PROCESS_NAMESPACES, false);
			parser.setInput(in, null);
			parser.nextTag();

			while (parser.next() != XmlPullParser.END_DOCUMENT) {
				if (parser.getEventType() != XmlPullParser.START_TAG) {
					continue;
				}
				String attrib = parser.getAttributeValue(0);
				String value = parser.nextText();

				// Log.d(TAG, attrib + " : " + value);

				strings.put(attrib, value);
			}
		} catch (IOException e) {
			e.printStackTrace();
		} catch (XmlPullParserException e) {
			e.printStackTrace();
		}
	}

	public String getString(String tag) {
		if (!strings.containsKey(tag)) {
			Log.e("StringPicker", tag + " : Not found");
		}
		return strings.get(tag);
	}

	public void process(ViewGroup root) {
		try {
			for (int i = 0; i < root.getChildCount(); i++) {
				View child = root.getChildAt(i);
				if (child instanceof ViewGroup) {
					process((ViewGroup) child);
				} else {
					Object tag = child.getTag();
					if (tag != null) {
						String strTag = (String) tag;
						String text = getString(strTag);

						if (text != null) {
							if (child instanceof EditText) {
								if (strTag.startsWith("hint")) {
									((EditText) child).setHint(text);
								} else {
									((EditText) child).setText(text);
								}
							} else if (child instanceof Button) {
								((Button) child).setText(text);
							} else if (child instanceof TextView) {
								((TextView) child).setText(text);
							}
						}
					}
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	@SuppressLint("NewApi")
	public void rtl(ViewGroup root) {
		try {
			for (int i = 0; i < root.getChildCount(); i++) {
				View child = root.getChildAt(i);
				if (child instanceof ViewGroup) {
					process((ViewGroup) child);
				} else if (child instanceof EditText) {
					EditText input = (EditText) child;
					input.setGravity(Gravity.RIGHT);
					/*
					 * try {
					 * input.setTextDirection(EditText.TEXT_DIRECTION_RTL); }
					 * catch (NoSuchMethodError ex) { ex.printStackTrace(); }
					 */
				} else if (child instanceof TextView) {
					TextView label = (TextView) child;
					label.setGravity(Gravity.RIGHT);
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	@SuppressLint("NewApi")
	public void ltr(ViewGroup root) {
		try {
			for (int i = 0; i < root.getChildCount(); i++) {
				View child = root.getChildAt(i);
				if (child instanceof ViewGroup) {
					process((ViewGroup) child);
				} else if (child instanceof EditText) {
					EditText input = (EditText) child;
					input.setGravity(Gravity.LEFT);
					try {
						// input.setTextDirection(EditText.TEXT_DIRECTION_LTR);
					} catch (NoSuchMethodError ex) {
						ex.printStackTrace();
					}
				} else if (child instanceof TextView) {
					TextView label = (TextView) child;
					label.setGravity(Gravity.LEFT);
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
}
