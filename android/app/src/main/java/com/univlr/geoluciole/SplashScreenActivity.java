package com.univlr.geoluciole;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.transition.Slide;
import android.view.Gravity;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.Interpolator;
import android.widget.ImageView;

import androidx.appcompat.app.AppCompatActivity;

import com.univlr.geoluciole.model.Logger;
import com.univlr.geoluciole.model.UserPreferences;

public class SplashScreenActivity extends AppCompatActivity {

    private static final String TAG = SplashScreenActivity.class.getSimpleName();
    ImageView spinner;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.splash_screen_activity);
        spinner = findViewById(R.id.spinner_view);
        // initialize logger
        Logger.init(this);

        // creation animation
        Animation a = AnimationUtils.loadAnimation(this, R.anim.progress_anim);
        a.setDuration(600);
        spinner.startAnimation(a);
        a.setInterpolator(new Interpolator() {
            private final int frameCount = 12;

            @Override
            public float getInterpolation(float input) {
                return (float)Math.floor(input*frameCount)/frameCount;
            }
        });

        // set transition
        getWindow().setEnterTransition(new Slide(Gravity.START));
        getWindow().setExitTransition(new Slide(Gravity.END));
    }

    @Override
    protected void onStart() {
        super.onStart();
        Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                UserPreferences userPreferences = UserPreferences.getInstance(SplashScreenActivity.this);
                Intent intent;
              //  if (userPreferences.hasGiveConsent()) {
                    intent = new Intent(getApplicationContext(), MainActivity.class);
              //  } else {
              //      intent = new Intent(getApplicationContext(), RGPDConsentementGPSActivity.class);
              //  }
                startActivity(intent);
                overridePendingTransition(R.transition.trans_left_in, R.transition.trans_left_out);
                finish();
            }
        }, 1500);
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
