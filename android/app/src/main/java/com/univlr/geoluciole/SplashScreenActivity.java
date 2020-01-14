package com.univlr.geoluciole;

import android.content.Intent;
import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;

public class SplashScreenActivity extends AppCompatActivity {

    private static final String TAG = SplashScreenActivity.class.getSimpleName();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.splash_screen_activity);
        Intent intent = new Intent(getApplicationContext(),
                RGPDConsentementGPSActivity.class);
        startActivity(intent);
        finish();
    }

  //  @Override
  //  protected void onStart() {
  //      super.onStart();
//
  //      // checking permissions
  //      ArrayList<Permission> unauthorizedPermissions = retrieveUnauthorizedPermissions();
  //      if(!unauthorizedPermissions.isEmpty()) {
  //          requestPermissions(unauthorizedPermissions);
  //      } else {
  //          enableGPSIfNeeded();
  //      }
  //  }
//
  //  @Override
  //  protected void onGPSEnabled() {
  //      Intent intent = new Intent(getApplicationContext(),
  //              MainActivity.class);
  //      startActivity(intent);
  //      finish();
  //  }

}
