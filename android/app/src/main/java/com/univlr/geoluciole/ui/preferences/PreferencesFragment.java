package com.univlr.geoluciole.ui.preferences;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProviders;

import com.univlr.geoluciole.CguActivity;
import com.univlr.geoluciole.R;

public class PreferencesFragment extends Fragment {

    public View onCreateView(@NonNull LayoutInflater inflater,
            ViewGroup container, Bundle savedInstanceState) {
        PreferencesViewModel preferencesViewModel =
                ViewModelProviders.of(this).get(PreferencesViewModel.class);
        final View root = inflater.inflate(R.layout.fragment_preferences, container, false);

        Button button = root.findViewById(R.id.button_license_agreement);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(root.getContext(), CguActivity.class));
            }
        });

        return root;
    }
}