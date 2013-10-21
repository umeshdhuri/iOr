package com.mlsdev.charityapp.fragments;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.mlsdev.charityapp.ActivityAbout;
import com.mlsdev.charityapp.ActivityNeedHelp;
import com.mlsdev.charityapp.ActivityProfile;
import com.mlsdev.charityapp.ActivityRequests;
import com.mlsdev.charityapp.R;

import java.util.ArrayList;
import java.util.Arrays;

/**
 * Created by android-dev on 27.08.13.
 */
public class MainScreenFragment extends Fragment {
    private String[] elements = {"I need help","My requests","I want to help","Who we are"};


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View root = inflater.inflate(R.layout.fragment_main_screen, container, false);
        setupViews(root);
        return root;
    }

    private void setupViews(View root) {
        /*Button needHelp = (Button)root.findViewById(R.id.btNeedHelp);
        needHelp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(getActivity(), ActivityNeedHelp.class);
                startActivity(intent);
            }
        });

        Button btProfile = (Button)root.findViewById(R.id.btProfile);
        btProfile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(getActivity(), ActivityProfile.class);
                startActivity(intent);
            }
        });

        Button btAbout = (Button)root.findViewById(R.id.btAbout);
        btAbout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(getActivity(), ActivityAbout.class);
                startActivity(intent);
            }
        });
        Button btRequests = (Button)root.findViewById(R.id.btRequests);
        btRequests.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(getActivity(), ActivityRequests.class);
                startActivity(intent);
            }
        });*/


        ListView lvMain = (ListView) root.findViewById(R.id.lvMain);
        lvMain.setAdapter(new MainListAdapter(getActivity(),R.layout.list_item_main, new ArrayList<String>(Arrays.asList(elements))));
        lvMain.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent;
                switch (position){
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
                }
            }
        });
    }

    class MainListAdapter extends ArrayAdapter<String> {

        private Context mContext;
        private int mLayoutResourceId;
        private ArrayList<String> mData = new ArrayList<String>();


        public MainListAdapter(Context context, int layoutResourceId, ArrayList<String> data) {
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
                holder.tvText = (TextView)row.findViewById(R.id.tvText);
                holder.ivImage = (ImageView)row.findViewById(R.id.ivImage);
                row.setTag(holder);
            } else {
                holder = (ItemHolder)row.getTag();
            }

            final String item = mData.get(position);
            holder.tvText.setText(item);
            switch(position){
                case 0:
                    holder.ivImage.setBackgroundResource(R.drawable.icon_1);
                    break;
                case 1:
                    holder.ivImage.setBackgroundResource(R.drawable.icon_2);
                    break;
                case 2:
                    holder.ivImage.setBackgroundResource(R.drawable.icon_3);
                    break;
                case 3:
                    holder.ivImage.setBackgroundResource(R.drawable.icon_4);
                    break;
            }

            return row;
        }

        class ItemHolder {
            TextView tvText;
            ImageView ivImage;
        }
    }

}
