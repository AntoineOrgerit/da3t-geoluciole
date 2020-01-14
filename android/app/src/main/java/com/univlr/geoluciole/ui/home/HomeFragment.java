package com.univlr.geoluciole.ui.home;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProviders;

import com.univlr.geoluciole.R;
import com.univlr.geoluciole.database.LocationTable;
import com.univlr.geoluciole.model.UserPreferences;
import com.univlr.geoluciole.sender.BulkObject;
import com.univlr.geoluciole.sender.HttpSender;

import java.io.IOException;
import java.util.List;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Response;


public class HomeFragment extends Fragment {

    private Button button;
    private Button sendButton;
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
        this.sendButton = root.findViewById(R.id.send_button);

        this.button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Log.d("Location count", ""+ new LocationTable(root.getContext()).countAll());
                Log.d("Location count", ""+ new LocationTable(root.getContext()).getAll().toString());
                Toast.makeText(root.getContext(), UserPreferences.getInstance(root.getContext()).toString(),
                        Toast.LENGTH_SHORT).show();
            }
        });

        this.sendButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                List<BulkObject> list = new LocationTable(root.getContext()).getAll();
                if (list.size() == 0) {
                    return;
                }
                String data = HttpSender.parseDataInBulk(list);
                String url = "http://datamuseum.univ-lr.fr/geolucioles/data/_bulk";

                Callback callback = new Callback() {
                    @Override
                    public void onFailure(Call call, IOException e) {
                        e.printStackTrace();
                    }

                    @Override
                    public void onResponse(Call call, Response response) throws IOException {
                        new LocationTable(root.getContext()).removeAll();
                        Log.d("debug http", response.body().string());
                        Log.d("debug http", response.message());
                        Log.d("debug http", response.toString());
                    }
                };
                new HttpSender()
                        .setData(data)
                        .setUrl(url)
                        .setCallback(callback)
                        .send();
            }
        });


        return root;
    }
}