package com.univlr.geoluciole.ui.home;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProviders;

import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.UserPreferences;
import com.univlr.geoluciole.ui.achievements.AchievementsFragment;


public class HomeFragment extends Fragment {

    private HomeViewModel homeViewModel;
    private ImageView iv;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        homeViewModel =
                ViewModelProviders.of(this).get(HomeViewModel.class);
        final View root = inflater.inflate(R.layout.fragment_home, container, false);
        final TextView textView = root.findViewById(R.id.text_stay_progression);
        /*homeViewModel.getText().observe(this, new Observer<String>() {
            @Override
            public void onChanged(@Nullable String s) {
                textView.setText(s);
            }
        });*/
        UserPreferences userPref = UserPreferences.getInstance(root.getContext());
        if (!userPref.getListUnlockedBadges().isEmpty()) {
            int index = userPref.getListUnlockedBadges().size() - 1;
            String idBadge = userPref.getListUnlockedBadges().get(index);
            this.iv = (ImageView) root.findViewById(R.id.last_achievement_image);
            this.iv.setImageResource(AchievementsFragment.getRessourceImageBadge(idBadge));
        }

        return root;
    }
}