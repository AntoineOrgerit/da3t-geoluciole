/*
 * Copyright (c) 2020, Martin Allusse and Alexandre Baret and Jessy Barritault and Florian
 * Bertonnier and Lisa Fougeron and François Gréau and Thibaud Lambert and Antoine
 * Orgerit and Laurent Rayez
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

package fr.univ_lr.geoluciole.ui.form;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import com.mobsandgeeks.saripaar.Validator;
import com.mobsandgeeks.saripaar.annotation.Checked;
import com.mobsandgeeks.saripaar.annotation.NotEmpty;
import com.mobsandgeeks.saripaar.annotation.Select;

import fr.univ_lr.geoluciole.R;
import fr.univ_lr.geoluciole.model.UserPreferences;
import fr.univ_lr.geoluciole.model.form.FormModel;

public class FormActivityStepThree extends AppCompatActivity {
    private static final String TAG = FormActivityStepThree.class.getSimpleName();

    private static final String FORM = "Form";
    private static final String STEP_ANONYMOUS = "2/3";

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
        // variable title
        TextView title = findViewById(R.id.form_title);
        // step
        // variable step
        TextView step = findViewById(R.id.form_step);
        if (!UserPreferences.getInstance(this).isAccountConsent()) {
            title.setText(R.string.form_title_anonym);
            step.setText(STEP_ANONYMOUS);
        }
        // liste déroulante
        this.spinnerWhomList = findViewById(R.id.spinner_list_whom);
        this.spinnerTransportList = findViewById(R.id.spinner_list_transport);

        // autre with whom
        this.otherInputLayout = findViewById(R.id.form_other_title);
        this.otherWithWhom = findViewById(R.id.other);
        this.otherInputLayout.setVisibility(View.GONE);

        // autre transport
        this.otherTransportInputLayout = findViewById(R.id.form_other_transport);
        this.otherTransport = findViewById(R.id.other_transport);
        this.otherTransportInputLayout.setVisibility(View.GONE);

        // radiogroup
        this.radiogroupPresenceChildren = findViewById(R.id.radio_group_presence_children);
        this.radiogroupPresenceTeens = findViewById(R.id.radio_group_presence_teens);
        this.radiogroupFirstTime = findViewById(R.id.radio_group_first_time);
        this.radiogroupKnowCity = findViewById(R.id.radio_group_know_city);
        this.radiogroupFiveTimes = findViewById(R.id.radio_group_five_times);
        this.radiogroupTwoMonths = findViewById(R.id.radio_group_two_months);

        // bouton précédent
        this.btnPrevious = findViewById(R.id.btn_prev);
        // bouton envoi
        this.btnSubmit = findViewById(R.id.btn_next);
    }

    /**
     * Méthode permettant de gérer le formulaire
     */
    private void formSetter() {
        form = (FormModel) getIntent().getSerializableExtra(FORM);
        Log.i(TAG, "formSetter, récupération du form : " + form);
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
        intent.putExtra(FORM, form);
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

        // si l'item sélectionné dans le spinner with whom est identique à "Autre" on récupère la valeur
        // du champ rempli par l'utilisateur sinon on prend la valeur du spinner
        if (String.valueOf(spinnerWhomList.getSelectedItem()).equalsIgnoreCase(getString(R.string.field_other_title))) {
            form.setWithWhom(String.valueOf(otherWithWhom.getText()));
        } else {
            form.setWithWhom(String.valueOf(spinnerWhomList.getSelectedItem()));
        }
        // si l'item sélectionné dans le spinner transport est identique à "Autre" on récupère la valeur
        // du champ rempli par l'utilisateur sinon on prend la valeur du spinner
        if (String.valueOf(spinnerTransportList.getSelectedItem()).equalsIgnoreCase(getString(R.string.field_other_title))) {
            form.setTransport(String.valueOf(otherTransport.getText()));
        } else {
            form.setTransport(String.valueOf(spinnerTransportList.getSelectedItem()));
        }

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
                // validation
                validatorListener.setRedirect(true);
                validator.validate();
                validatorListener.setRedirect(false);

            }

        };
    }

    private Boolean getRadioButtonValue(int selectedId) {
        RadioButton radioResponse = findViewById(selectedId);
        return (radioResponse != null && String.valueOf(radioResponse.getText()).equalsIgnoreCase(getString(R.string.form_yes_response)));
    }

    private AdapterView.OnItemSelectedListener CustomOnItemSelectedListener(final TextInputLayout inputLayout) {
        return new AdapterView.OnItemSelectedListener() {
            public void onItemSelected(AdapterView<?> parent, View view, int pos, long id) {
                if (parent.getItemAtPosition(pos).toString().equalsIgnoreCase(getString(R.string.field_other_title))) {
                    inputLayout.setVisibility(View.VISIBLE);
                } else {
                    inputLayout.setVisibility(View.GONE);
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> arg0) {
                // do nothing
            }
        };
    }
}
