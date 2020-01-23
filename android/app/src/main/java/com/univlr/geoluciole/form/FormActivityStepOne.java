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
import com.jaredrummler.android.device.DeviceName;
import com.mobsandgeeks.saripaar.Validator;
import com.mobsandgeeks.saripaar.annotation.Email;
import com.mobsandgeeks.saripaar.annotation.NotEmpty;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.FormModelWithConsent;
import com.univlr.geoluciole.model.UserPreferences;


public class FormActivityStepOne extends AppCompatActivity {
    private static final String TAG = FormActivityStepOne.class.getSimpleName();

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
    private FormModelWithConsent formWithoutConsent;

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
        formWithoutConsent = (FormModelWithConsent) getIntent().getSerializableExtra("Form");
        if (formWithoutConsent == null) {
            formWithoutConsent = new FormModelWithConsent(UserPreferences.getInstance(this).getId());
        } else {
            this.lastname.setText(formWithoutConsent.getLastname());
            this.firstname.setText(formWithoutConsent.getFirstname());
            this.email.setText(formWithoutConsent.getEmail());
            this.phone.setText(formWithoutConsent.getPhone());
            Log.i(TAG, "formSetter, formulaire chargé :" + formWithoutConsent);
        }
    }

    /**
     * Méthode initialisant le validateur
     */
    private void initValidatorListener() {
        validator = new Validator(FormActivityStepOne.this);
        validatorListener = new ValidationFormListener(FormActivityStepOne.this, FormActivityStepTwo.class, formWithoutConsent);
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
                // récupération des infos du device
                DeviceName.with(FormActivityStepOne.this).request(new DeviceName.Callback() {
                    @Override
                    public void onFinished(DeviceName.DeviceInfo info, Exception error) {
                        String name = info.marketName;
                        String model = info.model;
                        formWithoutConsent.setDevice(name + "|" + model);
                    }
                });
                formWithoutConsent.setVersion(getAndroidVersion());
                formWithoutConsent.setLastname(String.valueOf(lastname.getText()));
                formWithoutConsent.setFirstname(String.valueOf(firstname.getText()));
                formWithoutConsent.setEmail(String.valueOf(email.getText()));
                formWithoutConsent.setPhone(String.valueOf(phone.getText()));

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

    public String getAndroidVersion() {
        return Build.VERSION.RELEASE;
    }
}