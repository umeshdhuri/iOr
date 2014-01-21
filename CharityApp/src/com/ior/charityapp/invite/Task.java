package com.ior.charityapp.invite;

import android.app.Dialog;
import android.content.Context;
import android.os.AsyncTask;

public class Task extends AsyncTask<Object, Object, Object> {

	private Context context;
	private Dialog progress;

	public Task(Context context) {
		this.context = context;
	}

	@Override
	protected void onPreExecute() {
		super.onPreExecute();

		try {
			progress = DialogFactory.showOnlySpinningWheel(context);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	@Override
	protected Object doInBackground(Object... params) {
		return null;
	}

	@Override
	protected void onPostExecute(Object result) {
		super.onPostExecute(result);

		try {
			progress.dismiss();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
}
