package com.univlr.geoluciole.form;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.textfield.TextInputEditText;
import com.univlr.geoluciole.FormActivity;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.FormModelWithoutConsent;

import java.io.Serializable;

public class FormActivityStepOne extends AppCompatActivity {

    // variables infos générales
    private TextInputEditText lastname;
    private TextInputEditText firstname;
    private TextInputEditText email;

    // formulaire
    private FormModelWithoutConsent formWithoutConsent;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.form_activity_step_one);
        // init form
        formWithoutConsent = new FormModelWithoutConsent();

        // attributs set
        lastname = (TextInputEditText) findViewById(R.id.lastname);
        firstname = (TextInputEditText) findViewById(R.id.firstname);
        email = (TextInputEditText) findViewById(R.id.email);

        // show keyboard
        this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);

        // bouton envoi
        Button btnContinue = (Button) findViewById(R.id.btn_next);
        btnContinue.setOnClickListener(getPersonalData());
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
                formWithoutConsent.setLastname(String.valueOf(lastname.getText()));
                formWithoutConsent.setFirstname(String.valueOf(firstname.getText()));
                formWithoutConsent.setEmail(String.valueOf(email.getText()));

                Toast.makeText(FormActivityStepOne.this,
                        "OnClickListener : " +
                                "\nNom : " + lastname.getText() +
                                "\nPrénom : " + firstname.getText() +
                                "\nEmail : " + email.getText()
                        ,
                        Toast.LENGTH_SHORT).show();

                // redirection vers la seconde étape du form
                Intent intent = new Intent(getApplicationContext(),
                        FormActivityStepTwo.class);

                // on passe l'objet form à la seconde vue
                intent.putExtra("Form", formWithoutConsent);
                startActivity(intent);

                // ajout d'une transition type swipe
                overridePendingTransition(R.transition.trans_left_in, R.transition.trans_left_out);
                finish();

            }

        };
    }
}
