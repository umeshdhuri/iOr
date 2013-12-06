package com.ior.charityapp.fragments;

import java.util.ArrayList;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.ior.charityapp.models.Category;
import com.ior.charityapp.models.Helper;
import com.ior.charityappior.DialogActivity;
import com.ior.charityappior.R;

/**
 * Created by android-dev on 27.08.13.
 */
public class FragmentNeedHelpPeople extends ParentFragment {
    private final Category mCategory;
    private final ArrayList<Helper> mPeople;
    public FragmentNeedHelpPeople(Category category,ArrayList<Helper> people) {
        super();
        mCategory = category;
        mPeople = people;
    }
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View root = inflater.inflate(R.layout.fragment_need_help_peoples, container, false);
        setupView(root);
        return root;

    }

    private void setupView(View root) {

        TextView tvHeader = (TextView)root.findViewById(R.id.tvHeaderPeople);
        tvHeader.append(" \"" + mCategory.mName+ "\"" );


            ListView lvPeople = (ListView) root.findViewById(R.id.lvPeople);
            lvPeople.setAdapter(new PeopleAdapter(getActivity(),R.layout.people_list_item, mPeople));
            lvPeople.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    ((DialogActivity)getActivity()).showDialog(mPeople.get(position).mName,mCategory.mName, mPeople.get(position).mPhoneNumber);
                }
            });

    }
}
