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
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
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

package com.univlr.geoluciole.form;

import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.textfield.TextInputEditText;
import com.mobsandgeeks.saripaar.Validator;
import com.mobsandgeeks.saripaar.annotation.Email;
import com.mobsandgeeks.saripaar.annotation.NotEmpty;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.FormModelWithConsent;
import com.univlr.geoluciole.model.UserPreferences;


public class FormActivityStepOne extends AppCompatActivity {
    private static final String TAG = FormActivityStepOne.class.getSimpleName();
    private static final String FORM = "Form";

    // variables infos générales
    @NotEmpty(messageResId = R.string.form_err_required)
    private TextInputEditText lastname;
    @NotEmpty(messageResId = R.string.form_err_required)
    private TextInputEditText firstname;
    @NotEmpty(messageResId = R.string.form_err_required)
    @Email(messageResId = R.string.form_err_mail)
    private TextInputEditText email;
    @NotEmpty(messageResId = R.string.form_err_required)
    private TextInputEditText phone;
    // formulaire
    private FormModelWithConsent formWithConsent;

    // validation
    ValidationFormListener validatorListener;
    Validator validator;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.form_activity_step_one);
        // attributs set
        initUI();
        // set le form si defini
        formSetter();
        // cacher keyboard
        this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
        // bouton envoi
        Button btnContinue = (Button) findViewById(R.id.btn_next);
        btnContinue.setOnClickListener(getPersonalData());
        // init validator
        initValidatorListener();
    }

    /**
     * Méthode pour initialiser les éléments UI
     */
    private void initUI() {
        this.lastname = findViewById(R.id.lastname);
        this.firstname = findViewById(R.id.firstname);
        this.email = findViewById(R.id.email);
        this.phone = findViewById(R.id.phone);
    }

    /**
     * Méthode permettant de gérer le formulaire
     */
    private void formSetter() {
        formWithConsent = (FormModelWithConsent) getIntent().getSerializableExtra(FORM);
        if (formWithConsent == null) {
            formWithConsent = new FormModelWithConsent(UserPreferences.getInstance(this).getId());
        } else {
            this.lastname.setText(formWithConsent.getLastname());
            this.firstname.setText(formWithConsent.getFirstname());
            this.email.setText(formWithConsent.getEmail());
            this.phone.setText(formWithConsent.getPhone());
            Log.i(TAG, "formSetter, récupération du form : " + formWithConsent);
        }
    }

    /**
     * Méthode initialisant le validateur
     */
    private void initValidatorListener() {
        validator = new Validator(FormActivityStepOne.this);
        validatorListener = new ValidationFormListener(FormActivityStepOne.this, FormActivityStepTwo.class, formWithConsent);
        validator.setValidationListener(validatorListener);
    }

    /**
     * Méthode récupérant les données d'infos générales de l'utilisateur
     *
     * @return View.OnClickListener
     */
    private View.OnClickListener getPersonalData() {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                formWithConsent.setLastname(String.valueOf(lastname.getText()));
                formWithConsent.setFirstname(String.valueOf(firstname.getText()));
                formWithConsent.setEmail(String.valueOf(email.getText()));
                formWithConsent.setPhone(String.valueOf(phone.getText()));

                Toast.makeText(FormActivityStepOne.this,
                        "OnClickListener : " +
                                "\nNom : " + lastname.getText() +
                                "\nPrénom : " + firstname.getText() +
                                "\nEmail : " + email.getText() +
                                "\nPhone : " + phone.getText()
                        ,
                        Toast.LENGTH_SHORT).show();
                validatorListener.setRedirect(true);
                validator.validate();
                validatorListener.setRedirect(false);
            }

        };
    }
}