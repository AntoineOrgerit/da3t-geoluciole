package com.univlr.geoluciole;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;

import androidx.appcompat.app.AppCompatActivity;

public class RGPDConsentementGPSActivity extends AppCompatActivity {

    private CheckBox consentementCheckbox;
    private Button validate_button;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        this.consentementCheckbox = findViewById(R.id.rgpd_first_content_consentement_checkbox);
        this.validate_button = findViewById(R.id.rgpd_first_validate_button);
        this.validate_button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                boolean consentement = consentementCheckbox.isChecked();
                Intent intent = new Intent(getApplicationContext(),RGPDConsentementFormActivity.class);
            }
        });
        setContentView(R.layout.activity_rgpd_consentement_gps);
    }
}
