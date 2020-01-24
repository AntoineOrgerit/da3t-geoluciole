package com.univlr.geoluciole.ui.home;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.Transformation;
import android.widget.ProgressBar;
import android.widget.Switch;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.UserPreferences;

import java.util.Calendar;


public class HomeFragment extends Fragment {

    private ProgressBar progressBar;
    private View root;

    public View onCreateView(@NonNull LayoutInflater inflater,
            ViewGroup container, Bundle savedInstanceState) {
         root = inflater.inflate(R.layout.fragment_home, container, false);

        progressBar = root.findViewById(R.id.progressBar_stay_progression);
        updateProgressBar();
        return root;
    }

    public void updateProgressBar() {
        UserPreferences userPreferences = UserPreferences.getInstance(root.getContext());
        int from = progressBar.getProgress();
        int to = calculProgress(userPreferences);
        ProgressBarAnimation anim = new ProgressBarAnimation(progressBar, from, to);
        anim.setDuration(1000);
        progressBar.startAnimation(anim);
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