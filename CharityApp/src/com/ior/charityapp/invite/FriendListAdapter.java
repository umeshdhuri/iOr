package com.ior.charityapp.invite;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;

import android.content.ContentUris;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.provider.ContactsContract;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.ImageView;
import android.widget.TextView;

import com.ior.charityappior.R;

public class FriendListAdapter<T> extends BaseAdapter implements
		OnCheckedChangeListener, OnClickListener {

	private HashMap<Integer, Boolean> checkedList = new HashMap<Integer, Boolean>();
	private ArrayList<T> items = new ArrayList<T>();
	protected Context context;

	public FriendListAdapter(Context context) {
		this.context = context;
	}

	public void add(T item) {
		items.add(item);
	}

	// public void set(ArrayList<T> items) {
	// this.items = items;
	// }

	public void clear() {
		items.clear();
		checkedList.clear();
	}

	@Override
	public int getCount() {
		return items.size();
	}

	@Override
	public T getItem(int position) {
		return items.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		if (convertView == null) {
			LayoutInflater li = (LayoutInflater) context
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = li.inflate(R.layout.list_item_friend, null);

			ViewHolder holder = new ViewHolder();
			holder.icon = (ImageView) convertView.findViewById(R.id.img_icon);
			holder.check = (CheckBox) convertView.findViewById(R.id.check);
			holder.check.setOnCheckedChangeListener(this);
			holder.line1 = (TextView) convertView.findViewById(R.id.tv_line1);
			holder.line2 = (TextView) convertView.findViewById(R.id.tv_line2);
			holder.line3 = (TextView) convertView.findViewById(R.id.tv_line3);

			convertView.setTag(holder);
		}

		ViewHolder holder = (ViewHolder) convertView.getTag();
		holder.position = position;

		show(holder.line1, getLine1(position));
		show(holder.line2, getLine2(position));
		show(holder.line3, getLine3(position));

		holder.icon.setImageBitmap(getIcon(position));

		holder.check.setTag(position);
		holder.check.setChecked(isChecked(position));

		// update tag
		convertView.setTag(holder);

		// allow selection of row by touch
		convertView.setOnClickListener(this);

		return convertView;
	}

	@Override
	public void onClick(View v) {
		ViewHolder holder = (ViewHolder) v.getTag();
		// toggle row selection
		check(holder.position, !isChecked(holder.position));

		// update rows
		notifyDataSetChanged();
	}

	private void show(TextView label, String text) {
		if (text == null) {
			label.setVisibility(View.INVISIBLE);
		} else {
			label.setVisibility(View.VISIBLE);
			label.setText(text);
		}
	}

	protected Bitmap getIcon(int position) {
		return null;
	}

	public boolean isChecked(int position) {
		if (checkedList == null)
			return false;
		Boolean r = checkedList.get(position);
		if (r == null)
			return false;
		return r;
	}

	protected String getLine1(int position) {
		return "line1";
	}

	protected String getLine2(int position) {
		return "line2";
	}

	protected String getLine3(int position) {
		return "line3";
	}

	private static class ViewHolder {
		public int position;
		public ImageView icon;
		public CheckBox check;
		public TextView line1, line2, line3;
	}

	@Override
	public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
		check((Integer) buttonView.getTag(), isChecked);
	}

	protected void check(int pos, boolean isChecked) {
		checkedList.put(pos, isChecked);
	}

	protected Bitmap getPhoto(String contactID) {
		try {
			InputStream inputStream = ContactsContract.Contacts
					.openContactPhotoInputStream(context.getContentResolver(),
							ContentUris.withAppendedId(
									ContactsContract.Contacts.CONTENT_URI,
									new Long(contactID)));

			if (inputStream != null) {
				Bitmap photo = BitmapFactory.decodeStream(inputStream);
				inputStream.close();
				return photo;
			} else {
				InputStream is = null;
				Bitmap bmp = null;
				is = context.getResources().openRawResource(
						R.drawable.no_profile);
				// BitmapFactory.Options opts = new BitmapFactory.Options();
				// opts.outWidth = 200;
				// opts.outHeight = 200;
				// bmp = BitmapFactory.decodeStream(is, null, opts);
				bmp = BitmapFactory.decodeStream(is);
				return bmp;
			}
		} catch (IOException e) {
			e.printStackTrace();
		} catch (OutOfMemoryError error) {
			error.printStackTrace();
		}

		return null;
	}
}
