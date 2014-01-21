package com.ior.charityapp.invite;

import com.facebook.model.GraphUser;

import android.content.Context;

public class FacebookFriendListAdapter extends FriendListAdapter<GraphUser> {

	public FacebookFriendListAdapter(Context context) {
		super(context);
	}

	@Override
	protected String getLine1(int position) {
		return getItem(position).getName();
	}

}
