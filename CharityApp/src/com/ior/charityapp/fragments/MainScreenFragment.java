package com.ior.charityapp.fragments;

import static com.ior.charityappior.Utils.log;


import java.util.ArrayList;
import java.util.Arrays;

import android.R.string;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.preference.Preference;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.ior.charityapp.gps.GPS;
import com.ior.charityapp.lang.ViewProcessor;
import com.ior.charityappior.ActivityAbout;
import com.ior.charityappior.ActivityMain;
import com.ior.charityappior.ActivityNeedHelp;
import com.ior.charityappior.ActivityProfile;
import com.ior.charityappior.ActivityRequests;
import com.ior.charityappior.DialogActivity;
import com.ior.charityappior.Request;
import com.ior.charityappior.Utils;
import com.ior.charityapp.gps.GPS;
import com.ior.charityappior.R;



/**
 * Created by android-dev on 27.08.13.
 */
public class MainScreenFragment extends ParentFragment {

	private AlertDialog.Builder builder;
	public static final int CHANGE_LANGUAGE_VALUE = 101; 
	View root;
	String tempLang = "";
	String languageResponse;
	int selectedPosition;
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		root = inflater.inflate(R.layout.fragment_main_screen, container,
				false);
		setupViews(root);
		return root;
	}

	private void setupViews(View root) {
		/*
		 * Button needHelp = (Button)root.findViewById(R.id.btNeedHelp);
		 * needHelp.setOnClickListener(new View.OnClickListener() {
		 * 
		 * @Override public void onClick(View v) { Intent intent = new
		 * Intent(getActivity(), ActivityNeedHelp.class); startActivity(intent);
		 * } });
		 * 
		 * Button btProfile = (Button)root.findViewById(R.id.btProfile);
		 * btProfile.setOnClickListener(new View.OnClickListener() {
		 * 
		 * @Override public void onClick(View v) { Intent intent = new
		 * Intent(getActivity(), ActivityProfile.class); startActivity(intent);
		 * } });
		 * 
		 * Button btAbout = (Button)root.findViewById(R.id.btAbout);
		 * btAbout.setOnClickListener(new View.OnClickListener() {
		 * 
		 * @Override public void onClick(View v) { Intent intent = new
		 * Intent(getActivity(), ActivityAbout.class); startActivity(intent); }
		 * }); Button btRequests = (Button)root.findViewById(R.id.btRequests);
		 * btRequests.setOnClickListener(new View.OnClickListener() {
		 * 
		 * @Override public void onClick(View v) { Intent intent = new
		 * Intent(getActivity(), ActivityRequests.class); startActivity(intent);
		 * } });
		 */
		
		//getActivity().getParent().startService(new Intent(getActivity(), GPS.class));
		
		String[] elements = { stringPicker.getString("mlt_need_help"),
				stringPicker.getString("mlt_my_requests"),
				stringPicker.getString("mlt_want_to_help"),
				stringPicker.getString("mlt_who_we_are")
		};

		ListView lvMain = (ListView) root.findViewById(R.id.lvMain);
		lvMain.setAdapter(new MainListAdapter(getActivity(),
				R.layout.list_item_main, new ArrayList<String>(Arrays
						.asList(elements))));
		lvMain.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {
				Intent intent;
				switch (position) {
				case 0:
					intent = new Intent(getActivity(), ActivityNeedHelp.class);
					startActivity(intent);
					break;
				case 1:
					intent = new Intent(getActivity(), ActivityRequests.class);
					startActivity(intent);
					break;
				case 2:
					intent = new Intent(getActivity(), ActivityProfile.class);
					startActivity(intent);
					break;
				case 3:
					intent = new Intent(getActivity(), ActivityAbout.class);
					startActivity(intent);
					break;
				/*case 4:
					
					
					 final CharSequence[] items = {"English", "Hebrew"};
				        selectedPosition = 0;
				        
					builder = new AlertDialog.Builder(getActivity());
					builder.setTitle("Choose an option"); 
					
					if(getActivity().getSharedPreferences("app_settings", Context.MODE_PRIVATE).getString("lang", "").equalsIgnoreCase("English")) {
			        	selectedPosition = 0;
			        }else if(getActivity().getSharedPreferences("app_settings", Context.MODE_PRIVATE).getString("lang", "").equalsIgnoreCase("Hebrew")) {
			        	selectedPosition = 1;
			        }
			        
			        builder.setSingleChoiceItems(items, selectedPosition, new  DialogInterface.OnClickListener() { 
			            public void  onClick(DialogInterface dialog, int item) {
			          	  selectedPosition = ((AlertDialog)dialog).getListView().getCheckedItemPosition();
			          	  
			          			tempLang = (String) items[item];
			    	  			if(tempLang.length() > 0) {
					    			Log.d("Test", "innnnn");
					    			if(tempLang.equalsIgnoreCase("English"))
					    				((ActivityMain) getActivity()).showProgressDialogDynamic("Sending request");
					    			else
					    				((ActivityMain) getActivity()).showProgressDialogDynamic("שולח בקשה");
					    			
					    			new changeLanguage().execute();
					    		}
			    	  			
			    	  			dialog.cancel();
			                
			            } 
			         });
			         
			        builder.create();
			        builder.show();
					
				break;	*/
				}
			}
		});
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		
		tempLang = data.getExtras().getString("langTemp");
		
		if (requestCode == CHANGE_LANGUAGE_VALUE) {
			if(tempLang.length() > 0) {
			Log.d("Test", "innnnn");
			if(tempLang.equalsIgnoreCase("English"))
				((ActivityMain) getActivity()).showProgressDialogDynamic("Sending request");
			else
				((ActivityMain) getActivity()).showProgressDialogDynamic("שולח בקשה");
			
			new changeLanguage().execute();
			}
			
		}
		
		
	}
	
	
	class MainListAdapter extends ArrayAdapter<String> {

		private Context mContext;
		private int mLayoutResourceId;
		private ArrayList<String> mData = new ArrayList<String>();

		public MainListAdapter(Context context, int layoutResourceId,
				ArrayList<String> data) {
			super(context, layoutResourceId, data);
			this.mLayoutResourceId = layoutResourceId;
			this.mContext = context;
			this.mData = data;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			View row = convertView;
			ItemHolder holder;
			if (row == null) {
				LayoutInflater inflater = ((Activity) mContext)
						.getLayoutInflater();
				row = inflater.inflate(mLayoutResourceId, parent, false);
				holder = new ItemHolder();
				holder.tvText = (TextView) row.findViewById(R.id.tvText);
				holder.ivImage = (ImageView) row.findViewById(R.id.ivImage);
				row.setTag(holder);
			} else {
				holder = (ItemHolder) row.getTag();
			}

			holder.tvText.setText("");
			final String item = mData.get(position);
			holder.tvText.setText(item);
			switch (position) {
			case 0:
				if(getActivity().getSharedPreferences("app_settings",
						Context.MODE_PRIVATE).getString("lang", "").equalsIgnoreCase("English")) {
					holder.tvText.setText("I need help");
				}else{
					holder.tvText.setText("אני צריך עזרה");
				}
				
				holder.ivImage.setBackgroundResource(R.drawable.icon_1);
				break;
			case 1:
				if(getActivity().getSharedPreferences("app_settings",
						Context.MODE_PRIVATE).getString("lang", "").equalsIgnoreCase("English")) {
					holder.tvText.setText("My requests");
				}else{
					holder.tvText.setText("הבקשות שלי");
				}
				holder.ivImage.setBackgroundResource(R.drawable.icon_2);
				break;
			case 2:
				if(getActivity().getSharedPreferences("app_settings",
						Context.MODE_PRIVATE).getString("lang", "").equalsIgnoreCase("English")) {
					holder.tvText.setText("I Can Help");
				}else{
					holder.tvText.setText("אני רוצה לעזור");
				}
				
				holder.ivImage.setBackgroundResource(R.drawable.icon_3);
				break;
			case 3:
				if(getActivity().getSharedPreferences("app_settings",
						Context.MODE_PRIVATE).getString("lang", "").equalsIgnoreCase("English")) {
					holder.tvText.setText("Who we are");
				}else{
					holder.tvText.setText("אודות");
				}
				
				holder.ivImage.setBackgroundResource(R.drawable.icon_4);
				break;
			/*case 4:
				if(getActivity().getSharedPreferences("app_settings",
						Context.MODE_PRIVATE).getString("lang", "").equalsIgnoreCase("English")) {
					holder.tvText.setText("Change Language");
				}else{
					holder.tvText.setText("החלף שפה");
				}
				
				holder.ivImage.setBackgroundResource(R.drawable.icon_5);
				break;*/
			}

			return row;
		}

		class ItemHolder {
			TextView tvText;
			ImageView ivImage;
		}
	}
	
	private class changeLanguage extends AsyncTask<String, Void, Integer> {

		@Override
		protected void onPreExecute() {
			super.onPreExecute();
		}

		@Override
		protected Integer doInBackground(String... params) {
			changeLanguageSync();
			return 1;
		}

		@Override
		protected void onPostExecute(Integer result) {
			super.onPostExecute(result);
			
			((ActivityMain) getActivity()).closeProgressDialog();
			if (languageResponse == null) {
				
				((ActivityMain) getActivity()).showErrorToast();
				
				//Test Code
				
				/*getActivity().getSharedPreferences("app_settings",
						Context.MODE_PRIVATE).edit()
				.putString("lang", tempLang).commit();
				
				 try {
						ViewProcessor.process(getActivity(), (ViewGroup) getActivity().getWindow().getDecorView()
								.getRootView(), getLanguageFileName());
					} catch (Exception ex) {
						ex.printStackTrace();
					}
				 
				 	setupViews(root);*/
				 	
				//Test Code
				
			} else {
				
				getActivity().getSharedPreferences("app_settings",
						Context.MODE_PRIVATE).edit()
				.putString("lang", tempLang).commit();
				
				 try {
						ViewProcessor.process(getActivity(), (ViewGroup) getActivity().getWindow().getDecorView()
								.getRootView(), getLanguageFileName());
					} catch (Exception ex) {
						ex.printStackTrace();
					}
				 
				 	setupViews(root);
			}
		}
		
	}
	
	private void changeLanguageSync() {
		
		String passLang = "";
		if(tempLang.equalsIgnoreCase("English")) {
			passLang = "";
		}else{
			passLang = "he";
		}
		
		//log("Token Key", getActivity().getSharedPreferences("app_settings", Context.MODE_PRIVATE).getString("TOKEN_KEY", null));
		String TokenValue = getActivity().getSharedPreferences("app_settings", Context.MODE_PRIVATE).getString("TOKEN_KEY", null);
        
		languageResponse = Request.updateLanguage(getActivity(), passLang);
	}
	
	/*private class changeLanguage extends AsyncTask<String, Void, String>  {

		@Override
		protected String doInBackground(String... arg0) {
			// TODO Auto-generated method stub
			return Request.updateLanguage(
					getActivity().getSharedPreferences("app_settings", Context.MODE_PRIVATE).getString("TOKEN_KEY", ""), 
					tempLang);
		}
		
		@Override
		protected void onPostExecute(String result) {
			((ActivityMain) getActivity()).closeProgressDialog();
			if (result == null) {
				((ActivityMain) getActivity()).showErrorToast();
				
				//Test Code
				
				getActivity().getSharedPreferences("app_settings",
						Context.MODE_PRIVATE).edit()
				.putString("lang", tempLang).commit();
				
				 if(tempLang.equalsIgnoreCase("English")) {
					 try {
							ViewProcessor.process(getActivity(), (ViewGroup) getActivity().getWindow().getDecorView()
									.getRootView(), "english.xml");
						} catch (Exception ex) {
							ex.printStackTrace();
						}
				 }else{
					 try {
							ViewProcessor.process(getActivity(), (ViewGroup) getActivity().getWindow().getDecorView()
									.getRootView(), "hebrew.xml");
						} catch (Exception ex) {
							ex.printStackTrace();
						}
				 }
				 
				 	setupViews(root);
				 	
				//Test Code
				
			} else {
				
				getActivity().getSharedPreferences("app_settings",
						Context.MODE_PRIVATE).edit()
				.putString("lang", tempLang).commit();
				
				 if(tempLang.equalsIgnoreCase("English")) {
					 try {
							ViewProcessor.process(getActivity(), (ViewGroup) getActivity().getWindow().getDecorView()
									.getRootView(), "english.xml");
						} catch (Exception ex) {
							ex.printStackTrace();
						}
				 }else{
					 try {
							ViewProcessor.process(getActivity(), (ViewGroup) getActivity().getWindow().getDecorView()
									.getRootView(), "hebrew.xml");
						} catch (Exception ex) {
							ex.printStackTrace();
						}
				 }
				 
				 	setupViews(root);
			}
		}

		
		
	}*/
	
}
