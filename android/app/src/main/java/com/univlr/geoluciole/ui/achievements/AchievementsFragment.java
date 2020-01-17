package com.univlr.geoluciole.ui.achievements;

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

public class AchievementsFragment extends Fragment {

    private AchievementsViewModel achievementsViewModel;

    public View onCreateView(@NonNull LayoutInflater inflater,
            ViewGroup container, Bundle savedInstanceState) {
        achievementsViewModel =
                ViewModelProviders.of(this).get(AchievementsViewModel.class);
        View root = inflater.inflate(R.layout.fragment_achievements, container, false);
      /*  final TextView textView = root.findViewById(R.id.text_achievements);
        achievementsViewModel.getText().observe(this, new Observer<String>() {
            @Override
            public void onChanged(@Nullable String s) {
                textView.setText(s);
            }
        });*/
        return root;
    }
}