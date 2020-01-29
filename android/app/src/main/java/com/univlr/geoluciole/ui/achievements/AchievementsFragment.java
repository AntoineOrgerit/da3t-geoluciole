/*
 * Copyright (c) 2020, La Rochelle Université
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *  Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *  Neither the name of the University of California, Berkeley nor the
 *   names of its contributors may be used to endorse or promote products
 *   derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package com.univlr.geoluciole.ui.achievements;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;

import com.univlr.geoluciole.MainActivity;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.UserPreferences;

import java.math.RoundingMode;
import java.text.DecimalFormat;

/**
 * classe AchievementsFragment correspondant à la vue des badges
 */
public class AchievementsFragment extends Fragment implements BadgeListFragment.OnFragmentInteractionListener {
    private static final String TAG = AchievementsFragment.class.getSimpleName();
    private View root;
    private Fragment childFragment;
    private MainActivity context;
    private BadgeListFragment badgeListFragment;
    private OnFragmentInteractionListener mListener;
    
    
    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        root = inflater.inflate(R.layout.fragment_achievements, container, false);
        this.context = (MainActivity) root.getContext();
        updateDistance();
        return root;
    }
    
    
        @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        updateView();
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof OnFragmentInteractionListener) {
            this.mListener = (OnFragmentInteractionListener) context;
        } else {
            throw new RuntimeException(context.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }

    public void updateView() {
        FragmentTransaction transaction = getChildFragmentManager().beginTransaction();
        if (childFragment != null) {
          transaction.remove(childFragment);
        }
        childFragment = new BadgeListFragment();
        transaction.replace(R.id.badgeList_fragment_container, childFragment).commit();
    }

    @Override
    public void onDetach() {
        super.onDetach();
        this.mListener = null;
    }

    @Override
    public void onFragmentInteraction(Uri uri) {

    }

    public interface OnFragmentInteractionListener {
        void messageFromParentFragment(Uri uri);
    }
 
    public void updateDistance(){
        UserPreferences userPref = UserPreferences.getInstance(this.root.getContext());
        TextView textView = this.root.findViewById(R.id.distance_value);

        // définition de l'arrondi
        DecimalFormat df = new DecimalFormat("#.##");
        df.setRoundingMode(RoundingMode.HALF_UP);

        String unit = " m";
        float distance = userPref.getDistance();
        if(userPref.getDistance() > 1000){
            distance = distance / 1000;
            unit = " Km";
        }
        String dis = df.format(distance) + unit;
        textView.setText(dis);   
    }
}