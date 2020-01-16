package com.univlr.geoluciole.form;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.mobsandgeeks.saripaar.Validator;
import com.mobsandgeeks.saripaar.annotation.Checked;
import com.mobsandgeeks.saripaar.annotation.NotEmpty;
import com.mobsandgeeks.saripaar.annotation.Select;
import com.univlr.geoluciole.MainActivity;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.FormModel;

public class FormActivityStepThree extends AppCompatActivity {
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

   /* private RadioButton radioFirstTime;
    private RadioButton radioKnowCity;
    @Checked(messageResId = R.string.form_err_required)
    private RadioButton radioFiveTimes;
    @Checked(messageResId = R.string.form_err_required)
    private RadioButton radioTwoMonths;*/

    // variables bouton précédent
    private Button btnPrevious;
    // bouton de validation
    private Button btnSubmit;

    // formulaire
    private FormModel form;

    // validation
    ValidationFormListener validatorListener;
    Validator validator;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.form_activity_step_three);
        // recuperation de l'objet formulaire
        form = (FormModel) getIntent().getSerializableExtra("Form");
        // init éléments du form
        initUI();
        // init listeners
        initListenersButtons();
        // init validation
        initValidatorListener();
    }

    /**
     * Méthode pour initialiser les éléments UI
     */
    private void initUI() {
        // step
        this.step = (TextView) findViewById(R.id.form_step);
        if (/*UserPreferences.getInstance(FormActivityStepTwo.this).isConsent()*/false) {
            this.step.setText("2/2");
        }
        // liste déroulante
        this.spinnerWhomList = (Spinner) findViewById(R.id.spinner_list_whom);
        this.spinnerTransportList = (Spinner) findViewById(R.id.spinner_list_transport);

        // radiogroup
        this.radiogroupFirstTime = (RadioGroup) findViewById(R.id.radio_group_first_time);
        this.radiogroupKnowCity = (RadioGroup) findViewById(R.id.radio_group_know_city);
        this.radiogroupFiveTimes = (RadioGroup) findViewById(R.id.radio_group_five_times);
        this.radiogroupTwoMonths = (RadioGroup) findViewById(R.id.radio_group_two_months);
        // bouton précédent
        this.btnPrevious = (Button) findViewById(R.id.btn_prev);
        // bouton envoi
        this.btnSubmit = (Button) findViewById(R.id.btn_next);
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
        if (/*UserPreferences.getInstance(FormActivityStepTwo.this).isConsent()*/ true) {
            back();
        }
    }

    /**
     * Méthode initialisant le validateur
     */
    private void initValidatorListener() {
        validator = new Validator(FormActivityStepThree.this);
        validatorListener = new ValidationFormListener(FormActivityStepThree.this, MainActivity.class, form);
        validator.setValidationListener(validatorListener);
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

                // get selected radio button from radioGroup
                int selectedIdFirstTime = radiogroupFirstTime.getCheckedRadioButtonId();
                int selectedIdFKnowCity = radiogroupKnowCity.getCheckedRadioButtonId();
                int selectedIdFiveTimes = radiogroupFiveTimes.getCheckedRadioButtonId();
                int selectedIdTwoMonths = radiogroupTwoMonths.getCheckedRadioButtonId();

                // find the radiobutton by returned id
                form.setFirstTime(getRadioButtonValue(selectedIdFirstTime));
                form.setKnowCity(getRadioButtonValue(selectedIdFKnowCity));
                form.setFiveTimes(getRadioButtonValue(selectedIdFiveTimes));
                form.setTwoMonths(getRadioButtonValue(selectedIdTwoMonths));

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
            if (String.valueOf(radioResponseFirstTime.getText()).equals("Oui")) {
                return true;
            }
        }
        return false;
    }

    public AdapterView.OnItemSelectedListener CustomOnItemSelectedListener() {
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
