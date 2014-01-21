package com.ior.charityapp.fragments;

import static com.ior.charityappior.Utils.log;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import com.ior.charityappior.ActivityMain;
import com.ior.charityappior.DialogActivity;
import com.ior.charityappior.Request;
import com.ior.charityappior.Utils;
import com.ior.charityappior.R;

/**
 * Created by android-dev on 27.08.13.
 */
public class SendCodeFragment extends ParentFragment {

	private EditText mEtCode;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View root = inflater.inflate(R.layout.fragment_send_code, container,
				false);
		setupView(root);
		return root;
	}

	private void setupView(View root) {

		mEtCode = (EditText) root.findViewById(R.id.etCode);

		Button btContinue = (Button) root.findViewById(R.id.btContinue);
		btContinue.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				handleContinueClick();
			}
		});

		Button btResendCode = (Button) root.findViewById(R.id.btResend);
		btResendCode.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				((ActivityMain) getActivity()).showProgressDialog();
				new AsyncTask<Void, Void, String>() {

					@Override
					protected String doInBackground(Void... params) {
						log("pushId",
								"pushId "
										+ ((ActivityMain) getActivity())
												.getRegistrationId());
						return Request.registerUser(
								((ActivityMain) getActivity()).getName(),
								((ActivityMain) getActivity())
										.getRegistrationId(),
								((ActivityMain) getActivity()).getPhoneNumber(), getActivity());
					}

					@Override
					protected void onPostExecute(String result) {
						((ActivityMain) getActivity()).closeProgressDialog();
						if (result.equals("Error")) {
							((ActivityMain) getActivity()).showErrorToast();
						} else {
							((DialogActivity) getActivity())
									.showResendSuccessToast();
						}
					}
				}.execute();
			}
		});

	}

	private void handleContinueClick() {
		final String code = mEtCode.getText().toString();
		if (code.isEmpty()) {
			((DialogActivity) getActivity()).showEmptyValueToast();
			return;
		}
		((ActivityMain) getActivity()).showProgressDialog();
		new AsyncTask<Void, Void, String>() {

			@Override
			protected String doInBackground(Void... params) {
				return Request.login(getActivity(), code,
						((ActivityMain) getActivity()).getPhoneNumber());
			}

			@Override
			protected void onPostExecute(String result) {
				((ActivityMain) getActivity()).closeProgressDialog();
				if (Utils.TEST) {
					((ActivityMain) getActivity())
							.setFragment(new MainScreenFragment());
				} else {
					if (result.equals("Error")) {
						((ActivityMain) getActivity()).showErrorToast();
					} else {
						((ActivityMain) getActivity())
								.setFragment(new MainScreenFragment());
					}
				}
			}
		}.execute();
	}

}
