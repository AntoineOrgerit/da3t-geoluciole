package com.univlr.geoluciole.ui.preferences;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProviders;

import com.univlr.geoluciole.CguActivity;
import com.univlr.geoluciole.PartnerActivity;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.UserPreferences;
import com.univlr.geoluciole.sender.HttpProvider;


public class PreferencesFragment extends Fragment {

    private Handler handler;

    public View onCreateView(@NonNull LayoutInflater inflater,
            ViewGroup container, Bundle savedInstanceState) {
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

        handler = new Handler(Looper.getMainLooper()) {
            @Override
            public void handleMessage(Message message) {
                switch (message.what) {
                    case HttpProvider.CODE_HANDLER_GPS_COUNT:
                        Toast.makeText(getActivity(), "Send location : " + message.obj, Toast.LENGTH_SHORT).show();
                        break;
                    case HttpProvider.CODE_HANDLER_GPS_ERROR:
                        Toast.makeText(getActivity(), "Error : " + message.obj, Toast.LENGTH_SHORT).show();
                        break;
                }
            }
        };

        Button send_data_btn = root.findViewById(R.id.button_send_data);
        send_data_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                HttpProvider.sendGps(root.getContext(), handler);
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