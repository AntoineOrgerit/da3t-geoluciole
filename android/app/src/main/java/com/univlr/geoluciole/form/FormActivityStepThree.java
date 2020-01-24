package com.univlr.geoluciole.form;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.mobsandgeeks.saripaar.Validator;
import com.mobsandgeeks.saripaar.annotation.Checked;
import com.mobsandgeeks.saripaar.annotation.Select;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.FormModel;
import com.univlr.geoluciole.model.UserPreferences;

public class FormActivityStepThree extends AppCompatActivity {
    // variable title
    private TextView title;
    // variable step
    private TextView step;

    // variables listes déroulantes
    @Select(messageResId = R.string.form_err_required)
    private Spinner spinnerWhomList;
    @Select(messageResId = R.string.form_err_required)
    private Spinner spinnerTransportList;

    // variables radiogroup
    @Checked(messageResId = R.string.form_err_radio)
    private RadioGroup radiogroupFirstTime;
    @Checked(messageResId = R.string.form_err_radio)
    private RadioGroup radiogroupKnowCity;
    @Checked(messageResId = R.string.form_err_radio)
    private RadioGroup radiogroupFiveTimes;
    @Checked(messageResId = R.string.form_err_radio)
    private RadioGroup radiogroupTwoMonths;

    // variables bouton précédent
    private Button btnPrevious;
    // bouton de validation
    private Button btnSubmit;

    // formulaire
    private FormModel form;

    // validation
    private ValidationFormListener validatorListener;
    private Validator validator;

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
            this.step.setText("2/3");
        }
        // liste déroulante
        this.spinnerWhomList = (Spinner) findViewById(R.id.spinner_list_whom);
        this.spinnerTransportList = (Spinner) findViewById(R.id.spinner_list_transport);

        // radiogroup
        this.radiogroupFirstTime = (RadioGroup) findViewById(R.id.radio_group_first_time);
        this.radiogroupKnowCity = (RadioGroup) findViewById(R.id.radio_group_know_city);
        this.radiogroupFiveTimes = (RadioGroup) findViewById(R.id.radio_group_five_times);
        this.radiogroupTwoMonths = (RadioGroup) findViewById(R.id.radio_group_two_months);

        // radiobuttons

        // bouton précédent
        this.btnPrevious = (Button) findViewById(R.id.btn_prev);
        // bouton envoi
        this.btnSubmit = (Button) findViewById(R.id.btn_next);
    }

    /**
     * Méthode permettant de gérer le formulaire
     */
    private void formSetter() {
        form = (FormModel) getIntent().getSerializableExtra("Form");
        System.out.println("ETAPE 3/4 retrieved : " + form);
    }

    /**
     * Méthode pour ajouter les listeners
     */
    private void initListenersButtons() {
        // listes déroulantes listeners
        this.spinnerWhomList.setOnItemSelectedListener(CustomOnItemSelectedListener());
        this.spinnerTransportList.setOnItemSelectedListener(CustomOnItemSelectedListener());
        // bouton précédent
        this.btnPrevious.setOnClickListener(previousView());
        // bouton suivant
        this.btnSubmit.setOnClickListener(getAllResponsesFromForm());
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
                FormActivityStepTwo.class);
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
        validator = new Validator(FormActivityStepThree.this);
        validatorListener = new ValidationFormListener(FormActivityStepThree.this, FormActivityStepEnd.class, form);
        validator.setValidationListener(validatorListener);
    }

    private void saveToForm() {
        // get selected radio button from radioGroup
        int selectedIdFirstTime = radiogroupFirstTime.getCheckedRadioButtonId();
        int selectedIdFKnowCity = radiogroupKnowCity.getCheckedRadioButtonId();
        int selectedIdFiveTimes = radiogroupFiveTimes.getCheckedRadioButtonId();
        int selectedIdTwoMonths = radiogroupTwoMonths.getCheckedRadioButtonId();

        // set spinner to form
        form.setWithWhom(String.valueOf(spinnerWhomList.getSelectedItem()));
        form.setTransport(String.valueOf(spinnerTransportList.getSelectedItem()));

        // find the radiobutton by returned id - set the form
        form.setFirstTime(getRadioButtonValue(selectedIdFirstTime));
        form.setKnowCity(getRadioButtonValue(selectedIdFKnowCity));
        form.setFiveTimes(getRadioButtonValue(selectedIdFiveTimes));
        form.setTwoMonths(getRadioButtonValue(selectedIdTwoMonths));
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

                Toast.makeText(FormActivityStepThree.this,
                        "OnClickListener : " +
                                "\nVoyage avec : " + spinnerWhomList.getSelectedItem() +
                                "\nTransport : " + spinnerTransportList.getSelectedItem(),

                        Toast.LENGTH_SHORT).show();

                validatorListener.setRedirect(true);
                validator.validate();
                validatorListener.setRedirect(false);

            }

        };
    }

    private Boolean getRadioButtonValue(int selectedId) {
        RadioButton radioResponseFirstTime = (RadioButton) findViewById(selectedId);
        if (radioResponseFirstTime != null) {
            return String.valueOf(radioResponseFirstTime.getText()).equals("Oui");
        }
        return false;
    }

    private AdapterView.OnItemSelectedListener CustomOnItemSelectedListener() {
        return new AdapterView.OnItemSelectedListener() {
            public void onItemSelected(AdapterView<?> parent, View view, int pos, long id) {
                Toast.makeText(FormActivityStepThree.this,
                        "OnItemSelectedListener : " + parent.getItemAtPosition(pos).toString(),
                        Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onNothingSelected(AdapterView<?> arg0) {
                // TODO Auto-generated method stub
            }
        };
    }
}
