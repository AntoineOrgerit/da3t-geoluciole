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

package com.univlr.geoluciole.ui.home;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.Transformation;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.Switch;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.univlr.geoluciole.R;
import com.univlr.geoluciole.location.LocationUpdatesService;
import com.univlr.geoluciole.model.UserPreferences;
import com.univlr.geoluciole.sender.HttpProvider;
import com.univlr.geoluciole.ui.MainActivity;
import com.univlr.geoluciole.ui.achievements.BadgeListFragment;

import java.util.Calendar;


public class HomeFragment extends Fragment {

    private View root;
    private ProgressBar progressBar;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        root = inflater.inflate(R.layout.fragment_home, container, false);
        final TextView textView = root.findViewById(R.id.text_stay_progression);
        progressBar = root.findViewById(R.id.progressBar_stay_progression);

        final Switch switchData = root.findViewById(R.id.data_collection_switch);
        updateSwitch();
        switchData.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                UserPreferences userPreferences = UserPreferences.getInstance(root.getContext());
                userPreferences.setSendData(isChecked);
                userPreferences.store(root.getContext());
                updateSwitch();
            }
        });
        
        updateLastBadgeView();
        updateProgressBar();
        return root;
    }

    public void updateLastBadgeView() {
        UserPreferences userPref = UserPreferences.getInstance(root.getContext());
        if (userPref.getListUnlockedBadges() != null && !userPref.getListUnlockedBadges().isEmpty()) {
            int index = userPref.getListUnlockedBadges().size() - 1;
            String idBadge = userPref.getListUnlockedBadges().get(index);
            ImageView iv = root.findViewById(R.id.last_achievement_image);
            iv.setImageResource(BadgeListFragment.getRessourceImageBadge(idBadge));
        }
    }

    public void updateProgressBar() {
        UserPreferences userPreferences = UserPreferences.getInstance(root.getContext());
        int from = progressBar.getProgress();
        int to = calculProgress(userPreferences);
        ProgressBarAnimation anim = new ProgressBarAnimation(progressBar, from, to);
        anim.setDuration(1000);
        progressBar.startAnimation(anim);
    }

    public void updateSwitch() {
        if (root == null) {
            return;
        }
        UserPreferences userPreferences = UserPreferences.getInstance(root.getContext());
        Switch switchData = root.findViewById(R.id.data_collection_switch);
        if (!userPreferences.isGpsConsent() || !userPreferences.isGpsAutorize()) {
            switchData.setChecked(false);
            userPreferences.setSendData(false);
            userPreferences.store(root.getContext());
            return;
        }

        //set du switch en fonction des données stockées
        switchData.setChecked(userPreferences.isSendData());

        // dans tous les cas si la periode de validité est depassé on coupe la collect
        // ou que le consentement n'est pas donnée
        Calendar current = Calendar.getInstance();
        if (userPreferences.getEndValidity() < current.getTimeInMillis()){
            userPreferences.setSendData(false);
            switchData.setChecked(false);

            // stop tous les services de l'application (envoi automatique, récupération gps)
            stopServices();
            return;
        }

        if (userPreferences.isSendData()) {
            startServices();
        } else {
            stopServices();
        }
    }

    private void startServices() {
        // start envoi des données gps
        HttpProvider.activePeriodicSend(root.getContext());

        MainActivity mainActivity = (MainActivity) getActivity();
        if (mainActivity != null) {
            LocationUpdatesService locationUpdatesService = mainActivity.getmService();
            if (locationUpdatesService != null) {
                // start récupération des données gps
                locationUpdatesService.requestLocationUpdates();
            }
        }
    }

    private void stopServices() {
        // on envoi les données gps
        HttpProvider.sendGps(root.getContext());
        // stop l'envoi automatique des données
        HttpProvider.cancelPeriodicSend(root.getContext());

        MainActivity mainActivity = (MainActivity) getActivity();
        if (mainActivity != null) {
            LocationUpdatesService locationUpdatesService = mainActivity.getmService();
            if (locationUpdatesService != null) {
                // stop récupération des données gps
                locationUpdatesService.stopService();
            }
        }
    }

    private int calculProgress(UserPreferences userPreferences) {
        Calendar calendar = Calendar.getInstance();
        long start = userPreferences.getStartValidity();
        long end = userPreferences.getEndValidity();
        if (start == 0 || end == 0) {
            return 0;
        }
        double x = (calendar.getTimeInMillis() - start);
        double y = (end - start);
        double res = x / y;
        return (int) (res *100);
    }
}

class ProgressBarAnimation extends Animation {
    private final ProgressBar progressBar;
    private final float from;
    private final float  to;

    public ProgressBarAnimation(ProgressBar progressBar, float from, float to) {
        super();
        this.progressBar = progressBar;
        this.from = from;
        this.to = to;
    }

    @Override
    protected void applyTransformation(float interpolatedTime, Transformation t) {
        super.applyTransformation(interpolatedTime, t);
        float value = from + (to - from) * interpolatedTime;
        progressBar.setProgress((int) value);
    }
}