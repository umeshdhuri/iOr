package com.ior.charityapp.invite;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;

import com.google.android.gms.plus.PlusShare;
import com.ior.charityappior.DialogActivity;
import com.ior.charityappior.R;

public class InviteActivity extends DialogActivity implements OnClickListener {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_invite_friends);

		View fb = findViewById(R.id.vg_fb);
		View phone = findViewById(R.id.vg_phone);
		//View plus = findViewById(R.id.vg_plus);
		View gmail = findViewById(R.id.vg_gmail);

		fb.setOnClickListener(this);
		phone.setOnClickListener(this);
		//plus.setOnClickListener(this);
		gmail.setOnClickListener(this);
	}

	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.vg_fb) {
				Log.e("", "In invite Activity");
//			 Intent i = new Intent(this, NewFBShare.class);
//			 i.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
//			 startActivity(i);
		} else if (v.getId() == R.id.vg_phone) {
			Intent i = new Intent(this, PhoneFriendListActivity.class);
			i.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
			startActivity(i);
		/*} else if (v.getId() == R.id.vg_plus) {
			plus();*/
		} else if (v.getId() == R.id.vg_gmail) {
		}
	}

	private void plus() {
		// Launch the Google+ share dialog with attribution to your app.
		Intent shareIntent = new PlusShare.Builder(this)
				.setType("text/plain")
				.setText("iOr")
				.setContentUrl(
						Uri.parse("https://play.google.com/store/apps/details?id="
								+ getPackageName())).getIntent();

		startActivityForResult(shareIntent, 0);
	}
}
