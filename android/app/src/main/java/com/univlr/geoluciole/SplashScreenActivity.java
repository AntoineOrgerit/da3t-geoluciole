package com.univlr.geoluciole;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;

import com.univlr.geoluciole.permissions.Permission;

import java.util.ArrayList;

public class SplashScreenActivity extends LocationActivity {

    private static String TAG = SplashScreenActivity.class.getSimpleName();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.splash_screen_activity);
    }

    @Override
    protected void onStart() {
        super.onStart();

        // checking permissions
        ArrayList<Permission> unauthorizedPermissions = retrieveUnauthorizedPermissions();
        if(!unauthorizedPermissions.isEmpty()) {
            requestPermissions(unauthorizedPermissions);
        } else {
            enableGPSIfNeeded();
        }
    }

    @Override
    protected void onGPSEnabled() {
        Intent intent = new Intent(getApplicationContext(),
                MainActivity.class);
        startActivity(intent);
        finish();
    }

}
