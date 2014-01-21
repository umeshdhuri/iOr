package com.ior.charityapp.invite;

import android.content.Context;
import android.graphics.Bitmap;

public class PhoneFriendListAdapter extends FriendListAdapter<PhoneContact> {

	public PhoneFriendListAdapter(Context context) {
		super(context);
	}

	@Override
	protected String getLine1(int position) {
		return getItem(position).name;
	}

	@Override
	protected String getLine2(int position) {
		return getItem(position).phone;
	}

	@Override
	protected String getLine3(int position) {
		return null;
	}

	@Override
	protected Bitmap getIcon(int position) {
		return getItem(position).photo;
	}
}
