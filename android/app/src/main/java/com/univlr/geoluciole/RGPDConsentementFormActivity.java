package com.univlr.geoluciole;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;

import androidx.appcompat.app.AppCompatActivity;

import com.univlr.geoluciole.model.UserPreferences;

public class RGPDConsentementFormActivity extends AppCompatActivity {

    private Button validate_button;
    private CheckBox consentementCheckbox;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_rgpd_consentement_form);

        this.consentementCheckbox = findViewById(R.id.rgpd_second_content_consentement_checkbox);
        this.validate_button = findViewById(R.id.rgpd_second_validate_button);
        this.validate_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                boolean consentement = consentementCheckbox.isChecked();
                Intent intent;
                if (consentement) {
                    //todo Ajouter pour aller au form step 1
                    intent = new Intent(getApplicationContext(),MainActivity.class);
                } else {
                    //todo Ajouter pour aller au form step 2
                    intent = new Intent(getApplicationContext(), MainActivity.class);
                }
                // sauvegarde des préférences
                UserPreferences u = UserPreferences.getInstance(RGPDConsentementFormActivity.this);
                u.setAccountConsent(consentement);
                UserPreferences.storeInstance(RGPDConsentementFormActivity.this, u);

                startActivity(intent);
                finish();
            }
        });
    }
}