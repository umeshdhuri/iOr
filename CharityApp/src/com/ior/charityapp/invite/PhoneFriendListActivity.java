package com.ior.charityapp.invite;

import java.util.ArrayList;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.PendingIntent;
import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.Cursor;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.telephony.SmsManager;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.ior.charityappior.DialogActivity;
import com.ior.charityappior.R;
import com.ior.charityappior.Request;
import com.ior.charityappior.Request.OnInviteTextLoadListener;
import com.ior.charityappior.Utils;

public class PhoneFriendListActivity extends DialogActivity implements
		OnClickListener {

	public static final String TAG = "PhoneFriendListActivity";
	private PhoneFriendListAdapter adapter;
	private BroadcastReceiver smsSentReceiver, smsDeliveredReceiver;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_list_friends);

		init();
	}

	ArrayList<PendingIntent> piSent = new ArrayList<PendingIntent>();
	ArrayList<PendingIntent> piDeliver = new ArrayList<PendingIntent>();

	@Override
	protected void onStart() {
		super.onStart();
		loadData();

		PendingIntent sent = PendingIntent.getBroadcast(getBaseContext(), 0,
				new Intent("SMS_SENT"), 0);
		PendingIntent delivered = PendingIntent.getBroadcast(getBaseContext(),
				0, new Intent("SMS_DELIVERED"), 0);

		piSent.add(sent);
		piSent.add(delivered);

		smsSentReceiver = new BroadcastReceiver() {

			@Override
			public void onReceive(Context arg0, Intent arg1) {
				switch (getResultCode()) {
				case Activity.RESULT_OK:
					Toast.makeText(getBaseContext(), "SMS has been sent",
							Toast.LENGTH_SHORT).show();
					break;
				case SmsManager.RESULT_ERROR_GENERIC_FAILURE:
					Toast.makeText(getBaseContext(), "Generic Failure",
							Toast.LENGTH_SHORT).show();
					break;
				case SmsManager.RESULT_ERROR_NO_SERVICE:
					Toast.makeText(getBaseContext(), "No Service",
							Toast.LENGTH_SHORT).show();
					break;
				case SmsManager.RESULT_ERROR_NULL_PDU:
					Toast.makeText(getBaseContext(), "Null PDU",
							Toast.LENGTH_SHORT).show();
					break;
				case SmsManager.RESULT_ERROR_RADIO_OFF:
					Toast.makeText(getBaseContext(), "Radio Off",
							Toast.LENGTH_SHORT).show();
					break;
				default:
					break;
				}

			}
		};

		smsDeliveredReceiver = new BroadcastReceiver() {

			@Override
			public void onReceive(Context arg0, Intent arg1) {
				switch (getResultCode()) {
				case Activity.RESULT_OK:
					Toast.makeText(getBaseContext(), "SMS Delivered",
							Toast.LENGTH_SHORT).show();
					break;
				case Activity.RESULT_CANCELED:
					Toast.makeText(getBaseContext(), "SMS not delivered",
							Toast.LENGTH_SHORT).show();
					break;
				}
			}
		};
		registerReceiver(smsSentReceiver, new IntentFilter("SMS_SENT"));
		registerReceiver(smsDeliveredReceiver,
				new IntentFilter("SMS_DELIVERED"));
	}

	@Override
	protected void onPause() {
		unregisterReceiver(smsSentReceiver);
		unregisterReceiver(smsDeliveredReceiver);
		super.onPause();
	}

	private void init() {
		TextView title = (TextView) findViewById(R.id.txt_title);
		title.setTag("mlt_my_contact_list");

		ImageView icon = (ImageView) findViewById(R.id.img_icon);
		icon.setBackgroundResource(R.drawable.ic_phone);

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

		adapter = new PhoneFriendListAdapter(this);
		ListView list = (ListView) findViewById(R.id.list);
		list.setAdapter(adapter);
		list.setFastScrollEnabled(true);
	}

	AsyncTask<Object, Object, Object> loadingTask, sendingTask;

	public void loadData() {
		loadingTask = new AsyncTask<Object, Object, Object>() {

			private ProgressDialog progress;

			@Override
			protected String doInBackground(Object... params) {
				try {
					String WHERE_CONDITION = ContactsContract.Data.MIMETYPE
							+ " = '"
							+ ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE
							+ "'";
					String[] PROJECTION = { ContactsContract.Data.CONTACT_ID,
							ContactsContract.Data.DISPLAY_NAME,
							ContactsContract.Data.DATA1 };
					String SORT_ORDER = ContactsContract.Data.DISPLAY_NAME;

					Cursor cur = getContentResolver().query(
							ContactsContract.Data.CONTENT_URI, PROJECTION,
							WHERE_CONDITION, null, SORT_ORDER);
					if (cur.moveToFirst()) {
						do {
							try {
								String cid = cur.getString(0);
								String name = cur.getString(1);
								String phone = cur.getString(2);

								PhoneContact c = new PhoneContact();
								c.contactId = cid;
								c.name = name;
								c.phone = phone;
								// c.photo = getPhoto(cid);
								publishProgress(c);
							} catch (Exception ex) {
								ex.printStackTrace();
							}
						} while (cur.moveToNext());
					}

				} catch (Exception ex) {
					ex.printStackTrace();
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

				progress.dismiss();
				adapter.notifyDataSetChanged();
			}

			@Override
			protected void onProgressUpdate(Object... values) {
				super.onProgressUpdate(values);

				try {
					PhoneContact c = (PhoneContact) values[0];
					adapter.add(c);
					if (adapter.getCount() % 10 == 0) {
						// update after each 10 records
						adapter.notifyDataSetChanged();
					}
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}

		}.execute("");

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
	// bmp = BitmapFactory.decodeStream(is);
	// return bmp;
	// }
	// } catch (Exception e) {
	// e.printStackTrace();
	// }
	//
	// return null;
	// }

	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.btn_send_invite) {
			AlertDialog.Builder b = new AlertDialog.Builder(
					getActivityContext());
			b.setMessage(stringPicker.getString("mlt_sms_will_cost"));
			b.setPositiveButton(stringPicker.getString("mlt_yes"),
					new DialogInterface.OnClickListener() {

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
							sendInvite();
						}
					});
			b.setNegativeButton(stringPicker.getString("mlt_not_now"),
					new DialogInterface.OnClickListener() {

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
						}

					});
			b.show();
		}
	}

	private void sendInvite() {
		sendingTask = new Task(this) {
			private ProgressDialog pd;

			@Override
			protected void onPreExecute() {
				super.onPreExecute();
				publishProgress(1);
			}

			@Override
			protected Object doInBackground(Object... params) {
				try {

					Request.getInviteText(getApplicationContext(),
							new OnInviteTextLoadListener() {

								@Override
								public void onLoadPhoneInviteText(
										String invitetext) {
									try {
										if (invitetext == null) {
											Log.e(TAG, "SMS text is NULL");
										} else {
											for (int i = 0; i < adapter
													.getCount(); i++) {
												if (adapter.isChecked(i)) {
													PhoneContact c = adapter
															.getItem(i);
													Log.d(TAG,
															"sending SMS to "
																	+ c.name
																	+ "["
																	+ c.phone
																	+ "]");
													sendSMS(c.phone, invitetext);
												}
											}
										}
									} catch (Exception ex) {
										ex.printStackTrace();
									}
								}

								@Override
								public void onLoadFacebookInviteText(String text) {
									// unused
								}

								@Override
								public void onLoadEmailInviteText(String text) {
									// unused
								}
							}, isHebrew());

				} catch (Exception ex) {
					ex.printStackTrace();
				}
				return null;
			}

			@Override
			protected void onPostExecute(Object result) {
				super.onPostExecute(result);
				publishProgress(2);
				// adapter.notifyDataSetInvalidated();
				// adapter.notifyDataSetChanged();

			}

			@Override
			protected void onProgressUpdate(Object... values) {
				super.onProgressUpdate(values);

				switch (Integer.parseInt("" + values[0].toString())) {
				case 1:
					pd = ProgressDialog.show(getActivityContext(), null,
							stringPicker.getString("mlt_sending_sms"), true,
							false);
					break;

				case 2:
					pd.dismiss();
					break;
				}

			}

			private void sendSMS(String phone, String message) {
				SmsManager smsManager = SmsManager.getDefault();
				ArrayList<String> parts = smsManager.divideMessage(message);
				smsManager.sendMultipartTextMessage(phone, null, parts, piSent,
						piDeliver);
			}
		};
		sendingTask.execute();
	}

	private Activity getActivityContext() {
		if (getParent() != null)
			return getParent();

		return this;
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		if (loadingTask != null) {
			loadingTask.cancel(true);
		}
		if (sendingTask != null) {
			sendingTask.cancel(true);
		}
	}
}
