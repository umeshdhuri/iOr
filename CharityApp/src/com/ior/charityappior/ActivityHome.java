package com.ior.charityappior;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;

import com.ior.charityapp.fragments.MainScreenFragment;
import com.ior.charityapp.gps.GPS;
import com.ior.charityappior.R;

import android.util.Log;

public class ActivityHome extends DialogActivity {
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setFragment(new MainScreenFragment());
			
	}
	
	public void setFragment(Fragment fragment) {
		FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
		ft.setCustomAnimations(android.R.anim.slide_in_left,
				android.R.anim.slide_out_right);
		ft.replace(R.id.fragment, fragment);
		ft.commit();
	}

}
