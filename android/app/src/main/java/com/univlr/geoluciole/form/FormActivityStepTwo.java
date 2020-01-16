package com.univlr.geoluciole.form;

import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextWatcher;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.mobsandgeeks.saripaar.Validator;
import com.mobsandgeeks.saripaar.annotation.NotEmpty;
import com.mobsandgeeks.saripaar.annotation.Order;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.FormModel;

import java.util.Calendar;

public class FormActivityStepTwo extends AppCompatActivity {
    // variable title
    private TextView title;
    // variable step
    private TextView step;

    // variables dates et heures
    @Order(1)
    @NotEmpty(messageResId = R.string.form_err_required)
    private EditText txtDateArrivee;
    @Order(2)
    @NotEmpty(messageResId = R.string.form_err_required)
    private EditText txtTimeArrivee;
    @Order(3)
    @NotEmpty(messageResId = R.string.form_err_required)
    private EditText txtDateDepart;
    @Order(4)
    @NotEmpty(messageResId = R.string.form_err_required)
    private EditText txtTimeDepart;

    // variables boutons dates et heures
    private Button btnDatePickerArrivee;
    private Button btnTimePickerArrivee;
    private Button btnDatePickerDepart;
    private Button btnTimePickerDepart;

    // variables boutons precedent et suivant
    private Button btnPrevious;
    private Button btnContinue;

    private int mYear;
    private int mMonth;
    private int mDay;
    private int mHour;
    private int mMinute;

    private FormModel form;

    // validation
    ValidationFormListener validatorListener;
    Validator validator;
    TextWatcherListener textWatcherListener;
    TextWatcher textWatcher;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.form_activity_step_two);
        // init éléments du form
        initUI();
        // set le form si defini
        formSetter();
        // desactive les keyboards des inputs
        disableKeyboardOnInputClick();
        // init listeners inputs
        initListenersInput();
        // init listeners boutons
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
        if (/*UserPreferences.getInstance(FormActivityStepTwo.this).isConsent()*/false) {
            this.title.setText("Formulaire anonypisé");
            this.step.setText("1/2");
        }
        // date et heure arrivée boutons
        this.btnDatePickerArrivee = (Button) findViewById(R.id.btn_in_date);
        this.btnTimePickerArrivee = (Button) findViewById(R.id.btn_in_time);
        // date arrivée input
        this.txtDateArrivee = (EditText) findViewById(R.id.in_date);
        // heure arrivée input
        this.txtTimeArrivee = (EditText) findViewById(R.id.in_time);
        // date et heure de départ boutons
        this.btnDatePickerDepart = (Button) findViewById(R.id.btn_out_date);
        this.btnTimePickerDepart = (Button) findViewById(R.id.btn_out_time);
        // date départ input
        this.txtDateDepart = (EditText) findViewById(R.id.out_date);
        // heure départ input
        this.txtTimeDepart = (EditText) findViewById(R.id.out_time);
        // bouton précédent
        this.btnPrevious = (Button) findViewById(R.id.btn_prev);
        // cacher le bouton precedent si pas de consentement
        if (/*!UserPreferences.getInstance(FormActivityStepTwo.this).isConsent()*/false) {
            this.btnPrevious.setVisibility(View.INVISIBLE);
        }
        // bouton suivant
        this.btnContinue = (Button) findViewById(R.id.btn_next);
    }

    /**
     * Méthode permettant de gérer le formulaire
     */
    private void formSetter() {
        form = (FormModel) getIntent().getSerializableExtra("Form");
        if (form == null) {
            form = new FormModel();
        } else {
            txtDateArrivee.setText(form.getDateIn());
            txtTimeArrivee.setText(form.getTimeIn());
            txtDateDepart.setText(form.getDateOut());
            txtTimeDepart.setText(form.getTimeOut());
            System.out.println("ETAPE 2/3 retrieved : " + form);
        }
    }

    /**
     * Méthode pour désactiver l'affichage des keyboard au clic sur les input
     */
    private void disableKeyboardOnInputClick() {
        this.txtDateArrivee.setInputType(EditorInfo.TYPE_NULL);
        this.txtTimeArrivee.setInputType(EditorInfo.TYPE_NULL);
        this.txtDateDepart.setInputType(EditorInfo.TYPE_NULL);
        this.txtTimeDepart.setInputType(EditorInfo.TYPE_NULL);
    }

    /**
     * Méthode pour ajouter les listeners de DatePicker et Timepicker sur les inputs
     */
    private void initListenersInput() {
        this.txtDateArrivee.setOnClickListener(getAndSetTextDate(txtDateArrivee));
        this.txtTimeArrivee.setOnClickListener(getAndSetTextTime(txtTimeArrivee));
        this.txtDateDepart.setOnClickListener(getAndSetTextDate(txtDateDepart));
        this.txtTimeDepart.setOnClickListener(getAndSetTextTime(txtTimeDepart));
    }

    /**
     * Méthode pour ajouter les listeners
     */
    private void initListenersButtons() {
        // boutons listeners
        this.btnDatePickerArrivee.setOnClickListener(getAndSetTextDate(txtDateArrivee));
        this.btnTimePickerArrivee.setOnClickListener(getAndSetTextTime(txtTimeArrivee));
        this.btnDatePickerDepart.setOnClickListener(getAndSetTextDate(txtDateDepart));
        this.btnTimePickerDepart.setOnClickListener(getAndSetTextTime(txtTimeDepart));
        // bouton précédent
        this.btnPrevious.setOnClickListener(previousView());
        // bouton suivant
        this.btnContinue.setOnClickListener(getDateTimeData());
    }

    /**
     * Méthode initialisant le validateur
     */
    private void initValidatorListener() {
        validator = new Validator(FormActivityStepTwo.this);
        validatorListener = new ValidationFormListener(FormActivityStepTwo.this, FormActivityStepThree.class, form);
        validator.setValidationListener(validatorListener);
        //validator.setValidationMode(Validator.Mode.IMMEDIATE);
        textWatcherListener = new TextWatcherListener(this.validator);
        txtDateArrivee.addTextChangedListener(textWatcherListener);
        txtTimeArrivee.addTextChangedListener(textWatcherListener);
        txtDateDepart.addTextChangedListener(textWatcherListener);
        txtTimeDepart.addTextChangedListener(textWatcherListener);
    }

    private void saveToForm() {
        form.setDateIn(String.valueOf(txtDateArrivee.getText()));
        form.setTimeIn(String.valueOf(txtTimeArrivee.getText()));
        form.setDateOut(String.valueOf(txtDateDepart.getText()));
        form.setTimeOut(String.valueOf(txtTimeDepart.getText()));
    }

    /**
     * Méthode récupérant les données dates et heures d'arrivée et départ de La Rochelle
     * de l'utilisateur, met à jour l'objet formulaire avec les données
     *
     * @return View.OnClickListener
     */
    private View.OnClickListener getDateTimeData() {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                saveToForm();

                Toast.makeText(FormActivityStepTwo.this,
                        "OnClickListener : " +
                                "\nDate arrivée : " + txtDateArrivee.getText() +
                                "\nHeure arrivée : " + txtTimeArrivee.getText() +
                                "\nDate départ : " + txtDateDepart.getText() +
                                "\nHeure départ : " + txtTimeDepart.getText()
                        ,

                        Toast.LENGTH_SHORT).show();
                validatorListener.setRedirect(true);
                validator.validate();
                validatorListener.setRedirect(false);

            }

        };
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
     * Méthode permettant de revenir sur la première vue
     */
    private void back() {
        Intent intent = new Intent(getApplicationContext(),
                FormActivityStepOne.class);
        intent.putExtra("Form", form);
        startActivity(intent);
        overridePendingTransition(R.transition.trans_right_in, R.transition.trans_right_out);
        finish();
    }

    /**
     * Redéfinition de la méthode onBackPressed
     * afin de revenir sur le premier écran du formulaire si consentement
     * sinon réduit l'application
     */
    @Override
    public void onBackPressed() {
        if (/*UserPreferences.getInstance(FormActivityStepTwo.this).isConsent()*/ true) {
            saveToForm();
            back();
        } else {
            super.onBackPressed();
        }
    }

    /**
     * Méthode récupérant les dates d'arrivée et départ
     * de l'utilisateur à La Rochelle
     *
     * @param text EditText à setter
     * @return View.OnClickListener
     */
    private View.OnClickListener getAndSetTextDate(final EditText text) {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Get Current Date
                final Calendar c = Calendar.getInstance();
                mYear = c.get(Calendar.YEAR);
                mMonth = c.get(Calendar.MONTH);
                mDay = c.get(Calendar.DAY_OF_MONTH);

                DatePickerDialog datePickerDialog = new DatePickerDialog(FormActivityStepTwo.this, new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                        String month = monthOfYear < 10 ? "0" + (monthOfYear + 1) : (monthOfYear + 1) + "";
                        text.setText(dayOfMonth + "-" + month + "-" + year);
                    }
                }, mYear, mMonth, mDay);
                datePickerDialog.show();
            }
        };
    }

    /**
     * Méthode récupérant les heures d'arrivée et départ
     * de l'utilisateur à La Rochelle
     *
     * @param text EditText à setter
     * @return View.OnClickListener
     */
    private View.OnClickListener getAndSetTextTime(final EditText text) {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Get Current Time
                final Calendar c = Calendar.getInstance();
                mHour = c.get(Calendar.HOUR_OF_DAY);
                mMinute = c.get(Calendar.MINUTE);

                // Launch Time Picker Dialog
                TimePickerDialog timePickerDialog = new TimePickerDialog(FormActivityStepTwo.this, 0, new TimePickerDialog.OnTimeSetListener() {
                    @Override
                    public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                        String minutes = minute < 10 ? "0" + (minute + 1) : minute + "";
                        text.setText(hourOfDay + ":" + minutes);
                    }
                }, mHour, mMinute, true);
                timePickerDialog.show();
            }

        };
    }
}
