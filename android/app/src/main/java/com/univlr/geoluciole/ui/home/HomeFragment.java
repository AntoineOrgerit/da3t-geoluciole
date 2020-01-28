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
import androidx.fragment.app.Fragment;

import com.univlr.geoluciole.MainActivity;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.location.LocationUpdatesService;
import com.univlr.geoluciole.model.UserPreferences;
import com.univlr.geoluciole.sender.HttpProvider;
import com.univlr.geoluciole.ui.achievements.BadgeListFragment;

import java.util.Calendar;


public class HomeFragment extends Fragment {

    private ImageView iv;
    private View root;
    private ProgressBar progressBar;

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
        if (!userPref.getListUnlockedBadges().isEmpty()) {
            int index = userPref.getListUnlockedBadges().size() - 1;
            String idBadge = userPref.getListUnlockedBadges().get(index);
            this.iv = root.findViewById(R.id.last_achievement_image);
            this.iv.setImageResource(BadgeListFragment.getRessourceImageBadge(idBadge));
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
        UserPreferences userPreferences = UserPreferences.getInstance(root.getContext());
        Switch switchData = root.findViewById(R.id.data_collection_switch);

        //set du switch en fonction des données stockées
        switchData.setChecked(userPreferences.isSendData());

        // dans tous les cas si la periode de validité est depassé on coupe la collect
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
    private ProgressBar progressBar;
    private float from;
    private float  to;

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