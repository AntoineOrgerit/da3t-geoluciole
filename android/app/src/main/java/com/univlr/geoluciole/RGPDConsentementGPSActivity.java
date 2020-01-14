package com.univlr.geoluciole;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;

import androidx.appcompat.app.AppCompatActivity;

import com.univlr.geoluciole.model.UserPreferences;

public class RGPDConsentementGPSActivity extends AppCompatActivity {

    private CheckBox consentementCheckbox;
    private Button validate_button;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_rgpd_consentement_gps);

        this.consentementCheckbox = findViewById(R.id.rgpd_first_content_consentement_checkbox);
        this.validate_button = findViewById(R.id.rgpd_first_validate_button);
        this.validate_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                boolean consent = consentementCheckbox.isChecked();
                Intent intent;
                if (consent) {
                    intent = new Intent(getApplicationContext(), RGPDConsentementFormActivity.class);
                } else {
                    intent = new Intent(getApplicationContext(), MainActivity.class);
                }

                // sauvegarde des préférences
                UserPreferences u = UserPreferences.getInstance(RGPDConsentementGPSActivity.this);
                u.setGpsConsent(consent);
                UserPreferences.storeInstance(RGPDConsentementGPSActivity.this, u);

                startActivity(intent);
                finish();
            }
        });
    }
}