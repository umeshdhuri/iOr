package com.ior.charityapp.invite;

import android.content.Context;
import android.graphics.Bitmap;

public class DeviceEmailListAdapter  extends FriendListAdapter<PhoneContact> {

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
