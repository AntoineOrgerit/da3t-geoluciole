package com.univlr.geoluciole;

import android.content.Intent;
import android.os.Bundle;

import com.univlr.geoluciole.form.FormActivityStepOne;
import com.univlr.geoluciole.permissions.Permission;

import java.util.ArrayList;

public class SplashScreenActivity extends LocationActivity {

    private static final String TAG = SplashScreenActivity.class.getSimpleName();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.splash_screen_activity);
        Intent intent = new Intent(getApplicationContext(),
                FormActivityStepOne.class);
        startActivity(intent);
        finish();
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
