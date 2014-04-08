package com.ior.charityappior;

import android.os.Bundle;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.util.TypedValue;

import com.astuetz.viewpager.extensions.PagerSlidingTabStrip;
import com.ior.charityapp.fragments.AboutFragment;
import com.ior.charityappior.R;

import static com.ior.charityappior.Utils.log;

public class ActivityAbout extends DialogActivity {

	private PagerSlidingTabStrip tabs;
	private ViewPager pager;
	private MyPagerAdapter adapter;
	private int currentColor = 0xFF18a6d9;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_about);

		// show title
		setTitle(stringPicker.getString("mlt_title_about"));

		tabs = (PagerSlidingTabStrip) findViewById(R.id.tabs);
		pager = (ViewPager) findViewById(R.id.pager);
		adapter = new MyPagerAdapter(getSupportFragmentManager());

		pager.setAdapter(adapter);

		final int pageMargin = (int) TypedValue.applyDimension(
				TypedValue.COMPLEX_UNIT_DIP, 4, getResources()
						.getDisplayMetrics());
		pager.setPageMargin(pageMargin);

		tabs.setViewPager(pager);

		tabs.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
			@Override
			public void onPageScrolled(int i, float v, int i2) {

			}

			@Override
			public void onPageSelected(int i) {
				switch (i) {
				case 0:
					changeColor(0xFF18a6d9);
					break;
				case 1:
					changeColor(0xFF0ca3d9);
					break;
				case 2:
					changeColor(0xFF00a0d9);
					break;
				}
			}

			@Override
			public void onPageScrollStateChanged(int i) {

			}
		});

		changeColor(currentColor);
	}

	@Override
	protected void onStart() {
		super.onStart();
		if (getIntent().hasExtra("tabIndex")) {
			int tabIndex = getIntent().getIntExtra("tabIndex", 0);
			pager.setCurrentItem(tabIndex, true); 
		}
	}

	private void changeColor(int newColor) {
		tabs.setIndicatorColor(newColor);
		currentColor = newColor;
	}

	public class MyPagerAdapter extends FragmentPagerAdapter {

		private final String[] TITLES = {
				stringPicker.getString("mlt_description"),
				stringPicker.getString("mlt_concept"),
				stringPicker.getString("mlt_change_language"),
				stringPicker.getString("mlt_invite_friends") };

		public MyPagerAdapter(FragmentManager fm) {
			super(fm);
		}

		@Override
		public CharSequence getPageTitle(int position) {
			return TITLES[position];
		}

		@Override
		public int getCount() {
			return TITLES.length;
		}

		@Override
		public Fragment getItem(int position) {
			log("About View", "position === " + position);
			return AboutFragment.newInstance(position);
		}
	}

}