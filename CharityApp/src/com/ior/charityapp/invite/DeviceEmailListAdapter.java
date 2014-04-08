package com.ior.charityapp.invite;

import java.util.ArrayList;
import java.util.regex.Matcher;

import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.provider.ContactsContract;

public class DeviceEmailListAdapter extends FriendListAdapter<PhoneContact> {

	public DeviceEmailListAdapter(Context context) {
		super(context);
	}

	@Override
	protected String getLine1(int position) {
		return getItem(position).name;
	}

	@Override
	protected String getLine2(int position) {
		return getItem(position).email;

		// ArrayList<String> emails = getEmails(getItem(position).contactId);
		// if (emails == null || emails.size() == 0)
		// return null;
		// return emails.get(0);
	}

	@Override
	protected String getLine3(int position) {
		return null;
	}

	@Override
	protected Bitmap getIcon(int position) {
		return getPhoto(getItem(position).contactId);
	}

	public ArrayList<String> getEmails(String contactId) {
		ArrayList<String> emailPhoneList = new ArrayList<String>();
		Cursor emails = context.getContentResolver().query(
				ContactsContract.CommonDataKinds.Email.CONTENT_URI,
				null,
				ContactsContract.CommonDataKinds.Email.CONTACT_ID + " = "
						+ contactId, null, null);
		while (emails.moveToNext()) {
			// This would allow you get several email
			// addresses
			String emailAddress = emails
					.getString(emails
							.getColumnIndex(ContactsContract.CommonDataKinds.Email.DATA));
			if ((!emailAddress.equalsIgnoreCase(""))
					&& (emailAddress.contains("@"))) {
				emailPhoneList.add(emailAddress);
				// c.photo = getPhoto(id);
			}
		}
		emails.close();

		return emailPhoneList;
	}
}
