package com.mlsdev.charityapp.fragments;

/**
 * Created by android-dev on 09.09.13.
 */

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.Spannable;
import android.text.SpannableString;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.mlsdev.charityapp.R;

public class AboutFragment extends Fragment {

        private static final String ARG_POSITION = "position";

        private int position;
        
        private final int strings_about[]={R.string.description,R.string.concept,R.string.more};
        
        public static AboutFragment newInstance(int position) {
            AboutFragment f = new AboutFragment();
            Bundle b = new Bundle();
            b.putInt(ARG_POSITION, position);
            f.setArguments(b);
            return f;
        }

        @Override
        public void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);

            position = getArguments().getInt(ARG_POSITION);
        }

        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        	
            View root = inflater.inflate(R.layout.fragment_about, container, false);
            
            Spannable spanText = new SpannableString(getString(strings_about[position]));
            TextView tvText = (TextView) root.findViewById(R.id.tvAbout);
            tvText.setText(spanText);
            return root;

            /*LayoutParams params = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);

            FrameLayout fl = new FrameLayout(getActivity());
            fl.setLayoutParams(params);

            final int margin = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 8, getResources()
                    .getDisplayMetrics());

            TextView v = new TextView(getActivity());
            params.setMargins(margin, margin, margin, margin);
            v.setLayoutParams(params);
            v.setLayoutParams(params);
            v.setGravity(Gravity.CENTER);
            v.setBackgroundResource(R.drawable.background_card);
            v.setText(getResources().getString(R.string.about));
            fl.addView(v);
            return fl;*/
        }
}
