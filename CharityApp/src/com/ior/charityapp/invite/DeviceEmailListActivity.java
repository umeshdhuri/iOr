package com.ior.charityapp.invite;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.ContactsContract;
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

		loadData();
	}


	private void init() {
		TextView title = (TextView) findViewById(R.id.txt_title);
		title.setTag("mlt_my_email_list");

		ImageView icon = (ImageView) findViewById(R.id.img_icon);
		icon.setBackgroundResource(R.drawable.gmail_icon);

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


	public void getEmailContacts() 
	{

		try 
		{
			String name;

			ContentResolver cr = getContentResolver();
			Cursor cur = cr.query(ContactsContract.Contacts.CONTENT_URI, null,null, null, null);

			if (cur.getCount() > 0) 
			{
				ArrayList<String> emailNameList=new ArrayList<String>();
				ArrayList<String> emailPhoneList=new ArrayList<String>();
				while (cur.moveToNext()) 
				{
					String id = cur.getString(cur.getColumnIndex(ContactsContract.Contacts._ID));
					name = cur.getString(cur.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));

					Cursor emails = getContentResolver().query(ContactsContract.CommonDataKinds.Email.CONTENT_URI,null,
							ContactsContract.CommonDataKinds.Email.CONTACT_ID+ " = " + id, null, null);
					while (emails.moveToNext()) 
					{
						// This would allow you get several email addresses
						String emailAddress = emails.getString(emails.getColumnIndex(ContactsContract.CommonDataKinds.Email.DATA));
						Log.v(name+"==>", emailAddress);
						if ((!emailAddress.equalsIgnoreCase(""))&&(emailAddress.contains("@"))) 
						{   
							emailNameList.add(name);
							emailPhoneList.add(emailAddress);

							PhoneContact c = new PhoneContact();
							c.name = name;
							c.email = emailAddress;
							c.photo = getPhoto(id);
							adapter.add(c);
						}
					}
					emails.close();         
				}
			}
		}catch(Exception exception){
			exception.printStackTrace();
		}

	}
	public void loadData() {
		new AsyncTask<String, String, String>() {

			@Override
			protected void onPreExecute() {
				DeviceEmailListActivity.this.showProgressDialog();
				adapter.clear();
				adapter.notifyDataSetInvalidated();
				super.onPreExecute();
			}
			@Override
			protected String doInBackground(String... params) {
				getEmailContacts();
				return null;
			}

			@Override
			protected void onPostExecute(String result) {
				super.onPostExecute(result);
				DeviceEmailListActivity.this.closeProgressDialog();
				adapter.notifyDataSetChanged();
			}

		}.execute("");
	}

	private Bitmap getPhoto(String contactID) {
		try {
			InputStream inputStream = ContactsContract.Contacts
					.openContactPhotoInputStream(getContentResolver(),
							ContentUris.withAppendedId(
									ContactsContract.Contacts.CONTENT_URI,
									new Long(contactID)));

			if (inputStream != null) {
				Bitmap photo = BitmapFactory.decodeStream(inputStream);
				inputStream.close();
				return photo;
			}
		} catch (IOException e) {
			e.printStackTrace();
		}

		return null;
	}

	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.btn_send_invite) {

			new AsyncTask<String, String, String>(){
				String [] emailList;
				String invitetext ="";
				protected void onPreExecute() {
					emailList=new String[adapter.getCount()];

					for (int i = 0; i < adapter.getCount(); i++) {
						if (adapter.isChecked(i)) {
							PhoneContact c = adapter.getItem(i);
							Log.d(TAG, "sending SMS to " + c.name);
							emailList[i]=new String(c.email);
						}
					}
				}

				@Override
				protected String doInBackground(String... params) {
					invitetext = Request
							.getInviteText(getApplicationContext());
					return null;
				}

				protected void onPostExecute(String result) {
					Intent mail = new Intent(Intent.ACTION_SEND);
					mail.setType("text/html");
					mail.putExtra(Intent.EXTRA_EMAIL, emailList);
					mail.putExtra(Intent.EXTRA_SUBJECT, "Join iOr!");
					mail.putExtra(Intent.EXTRA_TEXT, ""+invitetext);
					startActivity(Intent.createChooser(mail,"Select Action..."));
				}
			}.execute("");
		}
	}
}
