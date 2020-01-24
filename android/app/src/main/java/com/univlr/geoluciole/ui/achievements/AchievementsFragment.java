package com.univlr.geoluciole.ui.achievements;

import android.app.Activity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProviders;

import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.badge.BadgeManager;

import java.io.IOException;
import java.io.InputStream;

public class AchievementsFragment extends Fragment {

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        View root = inflater.inflate(R.layout.fragment_achievements, container, false);
        BadgeManager badgeManager = BadgeManager.getInstance(root.getContext()); // root.getContext() dans le fragment
        badgeManager.instanciateObjFromJson();
        badgeManager.displayBadgesList();
        return root;
    }

}