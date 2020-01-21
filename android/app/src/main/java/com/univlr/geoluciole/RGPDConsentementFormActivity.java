package com.univlr.geoluciole;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;

import androidx.appcompat.app.AppCompatActivity;

import com.univlr.geoluciole.form.FormActivityStepOne;
import com.univlr.geoluciole.form.FormActivityStepTwo;
import com.univlr.geoluciole.model.UserPreferences;

public class RGPDConsentementFormActivity extends AppCompatActivity {

    private Button validate_button;
    private Button refused_button;
    private CheckBox consentementCheckbox;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_rgpd_consentement_form);

        this.consentementCheckbox = findViewById(R.id.rgpd_second_content_consentement_checkbox);
        this.validate_button = findViewById(R.id.rgpd_second_validate_button);
        this.refused_button = findViewById(R.id.rgpd_gps_consent_refused);

        this.consentementCheckbox.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                boolean consent = consentementCheckbox.isChecked();
                if (consent) {
                    validate_button.setBackgroundColor(getResources().getColor(R.color.colorPrimary));
                    refused_button.setBackgroundColor(getResources().getColor(R.color.colorDisabled));
                } else {
                    validate_button.setBackgroundColor(getResources().getColor(R.color.colorDisabled));
                    refused_button.setBackgroundColor(getResources().getColor(R.color.colorRefused));
                }
            }
        });


        this.validate_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                boolean consentement = consentementCheckbox.isChecked();
                if (!consentement) {
                    return;
                }

                Intent intent = new Intent(getApplicationContext(), FormActivityStepOne.class);
                // sauvegarde des préférences
                UserPreferences u = UserPreferences.getInstance(RGPDConsentementFormActivity.this);
                u.setAccountConsent(true);
                UserPreferences.storeInstance(RGPDConsentementFormActivity.this, u);

                startActivity(intent);
                finish();
            }
        });

        this.refused_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                boolean consent = consentementCheckbox.isChecked();
                if (consent) {
                    return;
                }
                Intent intent = new Intent(getApplicationContext(), FormActivityStepTwo.class);

                UserPreferences u = UserPreferences.getInstance(RGPDConsentementFormActivity.this);
                u.setAccountConsent(false);
                UserPreferences.storeInstance(RGPDConsentementFormActivity.this, u);

                startActivity(intent);
                finish();
            }
        });
    }
}
