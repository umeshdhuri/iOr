package com.ior.charityapp.invite;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.database.Cursor;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.provider.ContactsContract.CommonDataKinds;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.ior.charityapp.lang.ViewProcessor;
import com.ior.charityappior.DialogActivity;
import com.ior.charityappior.R;
import com.ior.charityappior.Request;
import com.ior.charityappior.Request.OnInviteTextLoadListener;
import com.ior.charityappior.Utils;

public class DeviceEmailListActivity extends DialogActivity implements
		OnClickListener {

	public static final String TAG = "DeviceEmailListActivity";
	private DeviceEmailListAdapter adapter;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_list_friends);

		init();

		// now process language
		try {
			ViewProcessor.process(this, (ViewGroup) getWindow().getDecorView(),
					getLanguageFileName());
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	@Override
	protected void onStart() {
		super.onStart();
		loadData();
	}

	private void init() {
		TextView title = (TextView) findViewById(R.id.txt_title);
		title.setTag("mlt_my_email_list");

		ImageView icon = (ImageView) findViewById(R.id.img_icon);
		icon.setBackgroundResource(R.drawable.ic_email);

		Button sendInvite = (Button) findViewById(R.id.btn_send_invite);
		sendInvite.setOnClickListener(this);

		CheckBox checkAll = (CheckBox) findViewById(R.id.check_all);
		checkAll.setOnCheckedChangeListener(new OnCheckedChangeListener() {

			@Override
			public void onCheckedChanged(CompoundButton buttonView,
					boolean isChecked) {
				if (adapter != null) {
					for (int i = 0; i < adapter.getCount(); i++) {
						adapter.check(i, isChecked);
					}
					adapter.notifyDataSetChanged();
				}
			}
		});

		adapter = new DeviceEmailListAdapter(this);
		ListView list = (ListView) findViewById(R.id.list);
		list.setAdapter(adapter);
		list.setFastScrollEnabled(true);
	}

	/*
	 * public void getEmailContacts() {
	 * 
	 * try { String name;
	 * 
	 * ContentResolver cr = getContentResolver(); Cursor cur =
	 * cr.query(ContactsContract.Contacts.CONTENT_URI, null,null, null, null);
	 * 
	 * if (cur.getCount() > 0) { ArrayList<String> emailNameList=new
	 * ArrayList<String>(); ArrayList<String> emailPhoneList=new
	 * ArrayList<String>(); while (cur.moveToNext()) { String id =
	 * cur.getString(cur.getColumnIndex(ContactsContract.Contacts._ID)); name =
	 * cur
	 * .getString(cur.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));
	 * 
	 * Cursor emails =
	 * getContentResolver().query(ContactsContract.CommonDataKinds
	 * .Email.CONTENT_URI,null,
	 * ContactsContract.CommonDataKinds.Email.CONTACT_ID+ " = " + id, null,
	 * null); while (emails.moveToNext()) { // This would allow you get several
	 * email addresses String emailAddress =
	 * emails.getString(emails.getColumnIndex
	 * (ContactsContract.CommonDataKinds.Email.DATA)); Log.v(name+"==>",
	 * emailAddress); if
	 * ((!emailAddress.equalsIgnoreCase(""))&&(emailAddress.contains("@"))) {
	 * emailNameList.add(name); emailPhoneList.add(emailAddress);
	 * 
	 * PhoneContact c = new PhoneContact(); c.name = name; c.email =
	 * emailAddress; c.photo = getPhoto(id); adapter.add(c); } } emails.close();
	 * } } }catch(Exception exception){ exception.printStackTrace(); }
	 * 
	 * }
	 */

	private AsyncTask<Object, Object, Object> loadingTask;
	private AsyncTask<Object, Object, Object> sendingTask;

	public void loadData() {
		loadingTask = new AsyncTask<Object, Object, Object>() {

			private ProgressDialog progress;

			@Override
			protected String doInBackground(Object... params) {
				// getEmailContacts();
				try {
					// map contact_id with names
					HashMap<String, String> names = new HashMap<String, String>();
					String[] p = { ContactsContract.Contacts._ID,
							ContactsContract.Contacts.DISPLAY_NAME };
					String sort = ContactsContract.Contacts.DISPLAY_NAME;

					Cursor c = getContentResolver().query(
							ContactsContract.Contacts.CONTENT_URI, p, null,
							null, sort);
					if (c.moveToFirst()) {
						do {
							try {
								String cid = c.getString(0);
								String name = c.getString(1);
								names.put(cid, name);
							} catch (Exception ex) {
								ex.printStackTrace();
							}
						} while (c.moveToNext());
					}

					// now fetch email ids

					String[] PROJECTION = { CommonDataKinds.Email.CONTACT_ID,
							CommonDataKinds.Email.DISPLAY_NAME,
							CommonDataKinds.Email.DATA1 };
					String SORT_ORDER = CommonDataKinds.Email.DATA1;

					Cursor cur = getContentResolver().query(
							CommonDataKinds.Email.CONTENT_URI, PROJECTION,
							null, null, SORT_ORDER);

					// create a list of records to sort later
					ArrayList<PhoneContact> contacts = new ArrayList<PhoneContact>();
					if (cur.moveToFirst()) {
						do {
							try {
								String email = cur.getString(2);
								if (isValidEmail(email)) {
									String cid = cur.getString(0);
									// String name = cur.getString(1);

									PhoneContact contact = new PhoneContact();
									contact.contactId = cid;
									// get name from names HashMap
									contact.name = names.get(cid);
									contact.email = email;
									// contact.photo = getPhoto(cid);

									contacts.add(contact);
								}
							} catch (Exception ex) {
								ex.printStackTrace();
							}
						} while (cur.moveToNext());
					}

					// sort the records
					Collections.sort(contacts, new Comparator<PhoneContact>() {

						@Override
						public int compare(PhoneContact lhs, PhoneContact rhs) {
							try {
								return lhs.name.compareToIgnoreCase(rhs.name);
							} catch (Exception ex) {
								return 0;
							} 
						}
					});

					// publish all the records
					for (PhoneContact pc : contacts) {
						publishProgress(pc);
					}

					// String[] PROJECTION = { ContactsContract.Contacts._ID,
					// ContactsContract.Contacts.DISPLAY_NAME };
					// String SORT_ORDER =
					// ContactsContract.Contacts.DISPLAY_NAME;
					//
					// Cursor cur = getContentResolver().query(
					// ContactsContract.Contacts.CONTENT_URI, PROJECTION,
					// null, null, SORT_ORDER);
					// if (cur.moveToFirst()) {
					// do {
					// try {
					// String cid = cur.getString(0);
					// if (hasEmail(cid)) {
					// String name = cur.getString(1);
					//
					// PhoneContact c = new PhoneContact();
					// c.contactId = cid;
					// c.name = name;
					// // c.photo = getPhoto(cid);
					// publishProgress(c);
					// }
					// } catch (Exception ex) {
					// ex.printStackTrace();
					// }
					// } while (cur.moveToNext());
					// }

					/*
					 * String name;
					 * 
					 * ContentResolver cr = getContentResolver(); Cursor cur =
					 * cr.query( ContactsContract.Contacts.CONTENT_URI, null,
					 * null, null, null);
					 * 
					 * if (cur.getCount() > 0) { ArrayList<String> emailNameList
					 * = new ArrayList<String>(); ArrayList<String>
					 * emailPhoneList = new ArrayList<String>(); while
					 * (cur.moveToNext()) {
					 * 
					 * if (isCancelled()) break;
					 * 
					 * String id = cur .getString(cur
					 * .getColumnIndex(ContactsContract.Contacts._ID)); name =
					 * cur .getString(cur
					 * .getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));
					 * 
					 * Cursor emails = getContentResolver()
					 * .query(ContactsContract
					 * .CommonDataKinds.Email.CONTENT_URI, null,
					 * ContactsContract.CommonDataKinds.Email.CONTACT_ID + " = "
					 * + id, null, null); while (emails.moveToNext()) { if
					 * (isCancelled()) break;
					 * 
					 * // This would allow you get several email // addresses
					 * String emailAddress = emails .getString(emails
					 * .getColumnIndex
					 * (ContactsContract.CommonDataKinds.Email.DATA));
					 * Log.v(name + "==>", emailAddress); if
					 * ((!emailAddress.equalsIgnoreCase("")) &&
					 * (emailAddress.contains("@"))) { emailNameList.add(name);
					 * emailPhoneList.add(emailAddress);
					 * 
					 * PhoneContact c = new PhoneContact(); c.contactId = id;
					 * c.name = name; c.email = emailAddress; // c.photo =
					 * getPhoto(id); publishProgress(c); } } emails.close(); } }
					 */

				} catch (Exception exception) {
					exception.printStackTrace();
				}
				return null;
			}

			@Override
			protected void onPreExecute() {
				super.onPreExecute();

				String loading = stringPicker.getString("mlt_loading");
				progress = Utils.showProgressDialog(loading,
						getActivityContext());
				adapter.clear();
				adapter.notifyDataSetInvalidated();
			}

			@Override
			protected void onPostExecute(Object result) {
				super.onPostExecute(result);

				adapter.notifyDataSetChanged();
				if (progress.isShowing())
					progress.dismiss();
			}

			@Override
			protected void onProgressUpdate(Object... values) {
				super.onProgressUpdate(values);
				try {
					PhoneContact c = (PhoneContact) values[0];
					adapter.add(c);
					// adapter.notifyDataSetChanged();
					// if (adapter.getCount() % 10 == 0) {
					// // update after each 10 records
					// if (progress.isShowing())
					// progress.dismiss();
					// }
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}

		};
		loadingTask.execute("");
	}

	// private Bitmap getPhoto(String contactID) {
	// try {
	// InputStream inputStream = ContactsContract.Contacts
	// .openContactPhotoInputStream(getContentResolver(),
	// ContentUris.withAppendedId(
	// ContactsContract.Contacts.CONTENT_URI,
	// new Long(contactID)));
	//
	// if (inputStream != null) {
	// Bitmap photo = BitmapFactory.decodeStream(inputStream);
	// inputStream.close();
	// return photo;
	// } else {
	// InputStream is = null;
	// Bitmap bmp = null;
	// is = getApplicationContext().getResources().openRawResource(
	// R.drawable.no_profile);
	// // BitmapFactory.Options opts = new BitmapFactory.Options();
	// // opts.outWidth = 200;
	// // opts.outHeight = 200;
	// // bmp = BitmapFactory.decodeStream(is, null, opts);
	// bmp = BitmapFactory.decodeStream(is);
	// return bmp;
	// }
	// } catch (IOException e) {
	// e.printStackTrace();
	// } catch (OutOfMemoryError error) {
	// error.printStackTrace();
	// }
	//
	// return null;
	// }

	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.btn_send_invite) {
			// cancel loading first
			if (loadingTask != null) {
				loadingTask.cancel(true);
			}

			sendingTask = new AsyncTask<Object, Object, Object>() {
				String[] emailList;
				String invitetext = "";

				@Override
				protected void onPreExecute() {
					publishProgress(1);
				}

				@Override
				protected String doInBackground(Object... params) {
					Request.getInviteText(getApplicationContext(),
							new OnInviteTextLoadListener() {

								@Override
								public void onLoadPhoneInviteText(String text) {
									// unused
								}

								@Override
								public void onLoadFacebookInviteText(String text) {
									// unused
								}

								@Override
								public void onLoadEmailInviteText(String text) {
									invitetext = text;
								}
							}, isHebrew());
					return null;
				}

				protected void onPostExecute(Object result) {
					publishProgress(2);
				}

				@Override
				protected void onProgressUpdate(Object... values) {
					super.onProgressUpdate(values);

					switch (Integer.parseInt("" + values[0].toString())) {
					case 1:

						ArrayList<String> selectedEmails = new ArrayList<String>();
						for (int i = 0; i < adapter.getCount(); i++) {
							if (adapter.isChecked(i)) {
								PhoneContact c = adapter.getItem(i);
								Log.d(TAG, "sending SMS to " + c.name);
								selectedEmails.add(c.email);
							}
						}
						emailList = selectedEmails.toArray(new String[0]);
						break;

					case 2:
						Intent mail = new Intent(Intent.ACTION_SEND);
						mail.setType("text/html");
						mail.putExtra(Intent.EXTRA_EMAIL, emailList);
						mail.putExtra(Intent.EXTRA_SUBJECT, "Join iOr!");
						mail.putExtra(Intent.EXTRA_TEXT, "" + invitetext);
						startActivity(Intent.createChooser(mail,
								"Select Action..."));
						break;
					}

				}
			}.execute("");
		}
	}

	private Activity getActivityContext() {
		if (getParent() != null)
			return getParent();

		return this;
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		// if (loadingTask != null) {
		// loadingTask.cancel(true);
		// }
		if (sendingTask != null) {
			sendingTask.cancel(true);
		}
	}

	// private boolean hasEmail(String contactId) {
	// try {
	// Cursor emails = getContentResolver().query(
	// ContactsContract.CommonDataKinds.Email.CONTENT_URI,
	// null,
	// ContactsContract.CommonDataKinds.Email.CONTACT_ID + " = "
	// + contactId, null, null);
	// return (emails != null && emails.getCount() > 0);
	// } catch (Exception ex) {
	// ex.printStackTrace();
	// }
	//
	// return false;
	// }

	public final static boolean isValidEmail(CharSequence target) {
		if (target == null) {
			return false;
		} else {
			return android.util.Patterns.EMAIL_ADDRESS.matcher(target)
					.matches();
		}
	}
}
