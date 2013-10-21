package com.mlsdev.charityapp.fragments;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.mlsdev.charityapp.R;
import com.mlsdev.charityapp.models.Helper;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

/**
 * Created by android-dev on 27.08.13.
 */
public class PeopleAdapter extends ArrayAdapter<Helper> {

    private Context mContext;
    private int mLayoutResourceId;
    private ArrayList<Helper> mData = new ArrayList<Helper>();


    public PeopleAdapter(Context context, int layoutResourceId, ArrayList<Helper> data) {
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
            LayoutInflater inflater = ((Activity) mContext).getLayoutInflater();
            row = inflater.inflate(mLayoutResourceId, parent, false);
            holder = new ItemHolder();
            holder.tvName = (TextView)row.findViewById(R.id.tvName);
            holder.tvDistance = (TextView)row.findViewById(R.id.tvDistance);
            holder.tvTime = (TextView)row.findViewById(R.id.tvTime);
            row.setTag(holder);
        } else {
            holder = (ItemHolder)row.getTag();
        }

        final Helper item = mData.get(position);
        holder.tvName.setText(item.mName);
        String distance = item.mDistance;
        holder.tvDistance.setText(distance.substring(0,distance.length()>4?4:distance.length())+"km");

        if(item.mDateTime!=null){
            Date date = null;
            holder.tvTime.setVisibility(View.VISIBLE);

            SimpleDateFormat  format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            try {
                date = format.parse(item.mDateTime);
                holder.tvTime.setText((System.currentTimeMillis()-date.getTime())/60000+ " min ago");
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        return row;
    }

    static class ItemHolder {
        TextView tvName;
        TextView tvDistance;
        TextView tvTime;
    }
}
