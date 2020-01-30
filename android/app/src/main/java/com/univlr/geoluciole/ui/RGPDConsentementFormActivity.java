/*
 * Copyright (c) 2020, La Rochelle Université
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *  Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *  Neither the name of the University of California, Berkeley nor the
 *   names of its contributors may be used to endorse or promote products
 *   derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package com.univlr.geoluciole.ui;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;

import androidx.appcompat.app.AppCompatActivity;

import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.UserPreferences;
import com.univlr.geoluciole.ui.form.FormActivityStepOne;
import com.univlr.geoluciole.ui.form.FormActivityStepTwo;

import java.util.Date;

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
                u.setDateConsentementForm(new Date().getTime());
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
