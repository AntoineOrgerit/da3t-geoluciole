package com.univlr.geoluciole.ui.home;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import androidx.annotation.Nullable;
import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProviders;

import com.univlr.geoluciole.R;
import com.univlr.geoluciole.database.LocationTable;
import com.univlr.geoluciole.sender.HttpSender;


public class HomeFragment extends Fragment {

    private Button button;
    private HomeViewModel homeViewModel;

    public View onCreateView(@NonNull LayoutInflater inflater,
            ViewGroup container, Bundle savedInstanceState) {
        homeViewModel =
                ViewModelProviders.of(this).get(HomeViewModel.class);
        final View root = inflater.inflate(R.layout.fragment_home, container, false);
        final TextView textView = root.findViewById(R.id.text_home);
        homeViewModel.getText().observe(this, new Observer<String>() {
            @Override
            public void onChanged(@Nullable String s) {
                textView.setText(s);
            }
        });

        this.button = root.findViewById(R.id.count_data);

        this.button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                //HttpSender.test(root.getContext());
                //Log.d("Location count", ""+ new LocationTable(root.getContext()).countAll());
                //Log.d("Location count", ""+ new LocationTable(root.getContext()).getAll().toString());
            }
        });

        return root;
    }
}