package com.univlr.geoluciole.form;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.mobsandgeeks.saripaar.Validator;
import com.univlr.geoluciole.MainActivity;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.FormModel;
import com.univlr.geoluciole.model.UserPreferences;

import java.util.Calendar;

public class FormActivityStepEnd extends AppCompatActivity {

    // variable title
    private TextView title;
    // variable step
    private TextView step;

    // variables bouton précédent
    private Button btnPrevious;
    // bouton de validation
    private Button btnSubmit;
    private Button startValidityPeriodBtn;
    private Button endValidityPeriodBtn;
    private EditText startValidityPeriodEditext;
    private EditText endValidityPeriodEditext;

    // formulaire
    private FormModel form;

    // validation
    ValidationFormListener validatorListener;
    Validator validator;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.form_activity_step_three);
        // init éléments du form
        initUI();
        // recuperation de l'objet formulaire
        formSetter();
        // init listeners
        initListenersButtons();
        // init validation
        initValidatorListener();
    }

    /**
     * Méthode pour initialiser les éléments UI
     */
    private void initUI() {
        // title
        this.title = (TextView) findViewById(R.id.form_title);
        // step
        this.step = (TextView) findViewById(R.id.form_step);
        if (!UserPreferences.getInstance(this).isAccountConsent()) {
            this.title.setText(R.string.form_title_anonym);
            this.step.setText("3/3");
        }

        // bouton précédent
        this.btnPrevious = (Button) findViewById(R.id.btn_prev);
        // bouton envoi
        this.btnSubmit = (Button) findViewById(R.id.btn_next);

        // bouton
        this.startValidityPeriodBtn = findViewById(R.id.start_validity_period_btn);
        this.endValidityPeriodBtn = findViewById(R.id.end_validity_period_btn);
        // editext
        this.startValidityPeriodEditext = findViewById(R.id.start_validity_period_editext);
        this.endValidityPeriodEditext = findViewById(R.id.end_validity_period_editext);
    }

    /**
     * Méthode permettant de gérer le formulaire
     */
    private void formSetter() {
        form = (FormModel) getIntent().getSerializableExtra("Form");
    }

    /**
     * Méthode pour ajouter les listeners
     */
    private void initListenersButtons() {
        // bouton précédent
        this.btnPrevious.setOnClickListener(previousView());
        // bouton suivant
        this.btnSubmit.setOnClickListener(getAllResponsesFromForm());

        Calendar c;
    }

    /**
     * Listener pour le bouton précédent, retour sur la vue précédente
     *
     * @return View.OnClickListener
     */
    private View.OnClickListener previousView() {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                saveToForm();
                back();
            }
        };
    }

    /**
     * Méthode permettant de revenir sur la deuxième vue
     */
    private void back() {
        Intent intent = new Intent(getApplicationContext(),
                FormActivityStepThree.class);
        intent.putExtra("Form", form);
        startActivity(intent);
        overridePendingTransition(R.transition.trans_right_in, R.transition.trans_right_out);
        finish();
    }

    /**
     * Redéfinition de la méthode onBackPressed
     * afin de revenir sur le second écran du formulaire
     */
    @Override
    public void onBackPressed() {
        saveToForm();
        back();
    }

    /**
     * Méthode initialisant le validateur
     */
    private void initValidatorListener() {
        validator = new Validator(FormActivityStepEnd.this);
        validatorListener = new ValidationFormListener(FormActivityStepEnd.this, MainActivity.class, form);
        validator.setValidationListener(validatorListener);
    }

    private void saveToForm() {

    }

    /**
     * Méthode récupérant les réponses de l'utilisateur
     * met à jour l'objet formulaire avec les données
     *
     * @return View.OnClickListener
     */
    private View.OnClickListener getAllResponsesFromForm() {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                saveToForm();

                Toast.makeText(FormActivityStepEnd.this,
                        "OnClickListener : ",
                        Toast.LENGTH_SHORT).show();

                validatorListener.setRedirect(true);
                validator.validate();
                validatorListener.setRedirect(false);

            }

        };
    }
}