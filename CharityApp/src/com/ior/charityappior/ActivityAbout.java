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

	/*
	 * @Override public boolean onCreateOptionsMenu(Menu menu) {
	 * getMenuInflater().inflate(R.menu.main, menu); return true; }
	 *//*
		 * @Override public boolean onOptionsItemSelected(MenuItem item) {
		 * 
		 * switch (item.getItemId()) {
		 * 
		 * case R.id.action_contact: QuickContactFragment dialog = new
		 * QuickContactFragment(); dialog.show(getSupportFragmentManager(),
		 * "QuickContactFragment"); return true;
		 * 
		 * }
		 * 
		 * return super.onOptionsItemSelected(item); }
		 */

	private void changeColor(int newColor) {

		tabs.setIndicatorColor(newColor);

		/*
		 * // change ActionBar color just if an ActionBar is available if
		 * (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
		 * 
		 * Drawable colorDrawable = new ColorDrawable(newColor); Drawable
		 * bottomDrawable =
		 * getResources().getDrawable(R.drawable.actionbar_bottom);
		 * LayerDrawable ld = new LayerDrawable(new Drawable[] { colorDrawable,
		 * bottomDrawable });
		 * 
		 * if (oldBackground == null) {
		 * 
		 * if (Build.VERSION.SDK_INT < Build.VERSION_CODES.JELLY_BEAN_MR1) {
		 * ld.setCallback(drawableCallback); } else {
		 * getActionBar().setBackgroundDrawable(ld); }
		 * 
		 * } else {
		 * 
		 * TransitionDrawable td = new TransitionDrawable(new Drawable[] {
		 * oldBackground, ld });
		 * 
		 * // workaround for broken ActionBarContainer drawable handling on //
		 * pre-API 17 builds //
		 * https://github.com/android/platform_frameworks_base
		 * /commit/a7cc06d82e45918c37429a59b14545c6a57db4e4 if
		 * (Build.VERSION.SDK_INT < Build.VERSION_CODES.JELLY_BEAN_MR1) {
		 * td.setCallback(drawableCallback); } else {
		 * getActionBar().setBackgroundDrawable(td); }
		 * 
		 * td.startTransition(200);
		 * 
		 * }
		 * 
		 * oldBackground = ld;
		 * 
		 * // http://stackoverflow.com/questions/11002691/actionbar-
		 * setbackgrounddrawable-nulling-background-from-thread-handler
		 * getActionBar().setDisplayShowTitleEnabled(false);
		 * getActionBar().setDisplayShowTitleEnabled(true);
		 * 
		 * }
		 */
		currentColor = newColor;
	}

	/*
	 * 
	 * public void onColorClicked(View v) {
	 * 
	 * int color = Color.parseColor(v.getTag().toString()); changeColor(color);
	 * 
	 * }
	 * 
	 * @Override protected void onSaveInstanceState(Bundle outState) {
	 * super.onSaveInstanceState(outState); outState.putInt("currentColor",
	 * currentColor); }
	 * 
	 * @Override protected void onRestoreInstanceState(Bundle
	 * savedInstanceState) { super.onRestoreInstanceState(savedInstanceState);
	 * currentColor = savedInstanceState.getInt("currentColor");
	 * changeColor(currentColor); }
	 * 
	 * private Drawable.Callback drawableCallback = new Drawable.Callback() {
	 * 
	 * @TargetApi(Build.VERSION_CODES.HONEYCOMB)
	 * 
	 * @Override public void invalidateDrawable(Drawable who) {
	 * getActionBar().setBackgroundDrawable(who); }
	 * 
	 * @Override public void scheduleDrawable(Drawable who, Runnable what, long
	 * when) { handler.postAtTime(what, when); }
	 * 
	 * @Override public void unscheduleDrawable(Drawable who, Runnable what) {
	 * handler.removeCallbacks(what); } };
	 */

	public class MyPagerAdapter extends FragmentPagerAdapter {

		private final String[] TITLES = {
				stringPicker.getString("mlt_description"),
				stringPicker.getString("mlt_concept"),
				stringPicker.getString("mlt_change_language"),
				stringPicker.getString("mlt_invite_friends")
		};

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