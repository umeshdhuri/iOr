package com.ior.charityapp.invite;

import java.util.ArrayList;
import java.util.HashMap;

import android.content.Context;
import android.graphics.Bitmap;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.ImageView;
import android.widget.TextView;

import com.ior.charityappior.R;

public class FriendListAdapter<T> extends BaseAdapter implements
		OnCheckedChangeListener {

	private HashMap<Integer, Boolean> checkedList = new HashMap<Integer, Boolean>();
	private ArrayList<T> items = new ArrayList<T>();
	protected Context context;

	public FriendListAdapter(Context context) {
		this.context = context;
	}

	public void add(T item) {
		items.add(item);
	}

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

		holder.line1.setText(getLine1(position));
		holder.line2.setText(getLine2(position));
		holder.line3.setText(getLine3(position));
		holder.icon.setImageBitmap(getIcon(position));

		holder.check.setTag(position);
		holder.check.setChecked(isChecked(position));

		return convertView;
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
}
