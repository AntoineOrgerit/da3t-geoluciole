package com.univlr.geoluciole.form;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import com.mobsandgeeks.saripaar.Validator;
import com.mobsandgeeks.saripaar.annotation.Checked;
import com.mobsandgeeks.saripaar.annotation.NotEmpty;
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
    private TextInputLayout otherInputLayout;
    @NotEmpty(messageResId = R.string.form_err_required)
    private TextInputEditText otherWithWhom;
    @Select(messageResId = R.string.form_err_required)
    private Spinner spinnerTransportList;
    private TextInputLayout otherTransportInputLayout;
    @NotEmpty(messageResId = R.string.form_err_required)
    private TextInputEditText otherTransport;

    // variables radiogroup
    @Checked(messageResId = R.string.form_err_radio)
    private RadioGroup radiogroupPresenceChildren;
    @Checked(messageResId = R.string.form_err_radio)
    private RadioGroup radiogroupPresenceTeens;
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
            this.step.setText("2/3");
        }
        // liste déroulante
        this.spinnerWhomList = (Spinner) findViewById(R.id.spinner_list_whom);
        this.spinnerTransportList = (Spinner) findViewById(R.id.spinner_list_transport);

        // autre with whom
        this.otherInputLayout = findViewById(R.id.form_other_title);
        this.otherWithWhom = findViewById(R.id.other);
        this.otherInputLayout.setVisibility(View.GONE);

        // autre transport
        this.otherTransportInputLayout = findViewById(R.id.form_other_transport);
        this.otherTransport = findViewById(R.id.other_transport);
        this.otherTransportInputLayout.setVisibility(View.GONE);

        // radiogroup
        this.radiogroupPresenceChildren = (RadioGroup) findViewById(R.id.radio_group_presence_children);
        this.radiogroupPresenceTeens = (RadioGroup) findViewById(R.id.radio_group_presence_teens);
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
     * Méthode permettant de gérer le formulaire
     */
    private void formSetter() {
        form = (FormModel) getIntent().getSerializableExtra("Form");
        //form = new FormModel("123");
        System.out.println("ETAPE 3/4 retrieved : " + form);
    }

    /**
     * Méthode pour ajouter les listeners
     */
    private void initListenersButtons() {
        // listes déroulantes listeners
        this.spinnerWhomList.setOnItemSelectedListener(CustomOnItemSelectedListener(otherInputLayout));
        this.spinnerTransportList.setOnItemSelectedListener(CustomOnItemSelectedListener(otherTransportInputLayout));
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
        int selectedIdPresenceChildren = radiogroupPresenceChildren.getCheckedRadioButtonId();
        int selectedIdPresenceTeens = radiogroupPresenceTeens.getCheckedRadioButtonId();
        int selectedIdFirstTime = radiogroupFirstTime.getCheckedRadioButtonId();
        int selectedIdFKnowCity = radiogroupKnowCity.getCheckedRadioButtonId();
        int selectedIdFiveTimes = radiogroupFiveTimes.getCheckedRadioButtonId();
        int selectedIdTwoMonths = radiogroupTwoMonths.getCheckedRadioButtonId();

        // set spinner to form
        if (String.valueOf(spinnerWhomList.getSelectedItem()).equalsIgnoreCase(getString(R.string.field_other_title))) {
            form.setWithWhom(String.valueOf(otherWithWhom.getText()));
        } else {
            form.setWithWhom(String.valueOf(spinnerWhomList.getSelectedItem()));
        }
        if (String.valueOf(spinnerTransportList.getSelectedItem()).equalsIgnoreCase(getString(R.string.field_other_title))) {
            form.setTransport(String.valueOf(otherTransport.getText()));
        } else {
            form.setTransport(String.valueOf(spinnerTransportList.getSelectedItem()));
        }

        System.out.println(form.getWithWhom());
        System.out.println(form.getTransport());

        // find the radiobutton by returned id - set the form
        form.setPresenceChildren(getRadioButtonValue(selectedIdPresenceChildren));
        form.setPresenceTeens(getRadioButtonValue(selectedIdPresenceTeens));
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
                                "\nTransport : " + spinnerTransportList.getSelectedItem() +
                                "\nAutre : " + otherWithWhom.getText(),

                        Toast.LENGTH_SHORT).show();

                validatorListener.setRedirect(true);
                validator.validate();
                validatorListener.setRedirect(false);

            }

        };
    }

    private Boolean getRadioButtonValue(int selectedId) {
        RadioButton radioResponse = (RadioButton) findViewById(selectedId);
        if (radioResponse != null) {
            if (String.valueOf(radioResponse.getText()).equalsIgnoreCase(getString(R.string.form_yes_response))) {
                return true;
            }
        }
        return false;
    }

    public AdapterView.OnItemSelectedListener CustomOnItemSelectedListener(final TextInputLayout inputLayout) {
        return new AdapterView.OnItemSelectedListener() {
            public void onItemSelected(AdapterView<?> parent, View view, int pos, long id) {
                Toast.makeText(FormActivityStepThree.this,
                        "OnItemSelectedListener : " + parent.getItemAtPosition(pos).toString(),
                        Toast.LENGTH_SHORT).show();
                if (parent.getItemAtPosition(pos).toString().equalsIgnoreCase(getString(R.string.field_other_title))) {
                    inputLayout.setVisibility(View.VISIBLE);
                } else {
                    inputLayout.setVisibility(View.GONE);
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> arg0) {
                // TODO Auto-generated method stub
            }
        };
    }
}
