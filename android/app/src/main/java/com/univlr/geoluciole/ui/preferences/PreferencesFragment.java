package com.univlr.geoluciole.ui.preferences;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProviders;

import com.univlr.geoluciole.CguActivity;
import com.univlr.geoluciole.PartnerActivity;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.UserPreferences;

public class PreferencesFragment extends Fragment {

    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        PreferencesViewModel preferencesViewModel =
                ViewModelProviders.of(this).get(PreferencesViewModel.class);
        final View root = inflater.inflate(R.layout.fragment_preferences, container, false);
        UserPreferences userPref = UserPreferences.getInstance(root.getContext());
        String id = userPref.getId();
        if (id != null) {
            TextView id_view = root.findViewById(R.id.id_textview);
            id_view.setText(id);
        }
        Button button = root.findViewById(R.id.button_license_agreement);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(root.getContext(), CguActivity.class));
            }
        });
        Button buttonPartners = root.findViewById(R.id.button_partners);
        buttonPartners.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(root.getContext(), PartnerActivity.class));
            }
        });
        return root;
    }
}