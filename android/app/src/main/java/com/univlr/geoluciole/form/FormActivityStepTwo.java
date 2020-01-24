package com.univlr.geoluciole.form;

import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.jaredrummler.android.device.DeviceName;
import com.mobsandgeeks.saripaar.Validator;
import com.mobsandgeeks.saripaar.annotation.NotEmpty;
import com.mobsandgeeks.saripaar.annotation.Order;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.FormModel;
import com.univlr.geoluciole.model.Time;
import com.univlr.geoluciole.model.UserPreferences;

import java.util.Calendar;
import java.util.Date;

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
    private Date dateDepart;
    private Date dateArrive;
    private Time timeDepart;
    private Time timeArrive;

    // validation
    ValidationFormListener validatorListener;
    Validator validator;
    TextWatcherListener textWatcherListener;

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
        if (!UserPreferences.getInstance(FormActivityStepTwo.this).isAccountConsent()) {
            this.title.setText(R.string.form_title_anonym);
            this.step.setText("1/3");
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
        if (!UserPreferences.getInstance(FormActivityStepTwo.this).isAccountConsent()) {
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
            UserPreferences userPref = UserPreferences.getInstance(FormActivityStepTwo.this);
            form = new FormModel(userPref.getId());
        } else {
            this.dateArrive = form.getDateIn();
            this.timeArrive = form.getTimeIn();
            this.dateDepart = form.getDateOut();
            this.timeDepart = form.getTimeOut();
            if(this.dateDepart != null && dateArrive != null) {
                txtDateArrivee.setText(FormModel.dateToString(this.dateArrive));
                txtTimeArrivee.setText(FormModel.timeToString(this.timeArrive));
                txtDateDepart.setText(FormModel.dateToString(this.dateDepart));
                txtTimeDepart.setText(FormModel.timeToString(this.timeDepart));
            }
            System.out.println("ETAPE 2/4 retrieved : " + form);
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
        this.txtDateArrivee.setOnClickListener(getAndSetTextDate(txtDateArrivee, false));
        this.txtTimeArrivee.setOnClickListener(getAndSetTextTime(txtTimeArrivee, false));
        this.txtDateDepart.setOnClickListener(getAndSetTextDate(txtDateDepart, true));
        this.txtTimeDepart.setOnClickListener(getAndSetTextTime(txtTimeDepart, true));
    }

    /**
     * Méthode pour ajouter les listeners
     */
    private void initListenersButtons() {
        // boutons listeners
        this.btnDatePickerArrivee.setOnClickListener(getAndSetTextDate(txtDateArrivee, false));
        this.btnTimePickerArrivee.setOnClickListener(getAndSetTextTime(txtTimeArrivee, false));
        this.btnDatePickerDepart.setOnClickListener(getAndSetTextDate(txtDateDepart, true));
        this.btnTimePickerDepart.setOnClickListener(getAndSetTextTime(txtTimeDepart, true));
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
        Calendar cal = Calendar.getInstance();
        // récupération des infos du device
        DeviceName.with(FormActivityStepTwo.this).request(new DeviceName.Callback() {
            @Override
            public void onFinished(DeviceName.DeviceInfo info, Exception error) {
                String name = info.marketName;
                String model = info.model;
                form.setDevice(name + "|" + model);
            }
        });
        form.setVersion(getAndroidVersion());

        // depart
        if (dateDepart != null && timeDepart != null) {
            form.setDateOut(this.dateDepart);
            form.setTimeOut(this.timeDepart);
        }
        // arrive
        if (dateArrive != null && timeArrive != null) {
            form.setTimeIn(this.timeArrive);
            form.setDateIn(this.dateArrive);
        }
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
                back();
            }
        };
    }

    /**
     * Méthode permettant de revenir sur la première vue
     */
    private void back() {
        if (UserPreferences.getInstance(FormActivityStepTwo.this).isAccountConsent()) {
            saveToForm();
            Intent intent = new Intent(getApplicationContext(),
                    FormActivityStepOne.class);
            intent.putExtra("Form", form);
            startActivity(intent);
            overridePendingTransition(R.transition.trans_right_in, R.transition.trans_right_out);
            finish();
        } else {
            super.onBackPressed();
        }
    }

    /**
     * Redéfinition de la méthode onBackPressed
     * afin de revenir sur le premier écran du formulaire si consentement
     * sinon réduit l'application
     */
    @Override
    public void onBackPressed() {
        back();
    }

    /**
     * Méthode récupérant les dates d'arrivée et départ
     * de l'utilisateur à La Rochelle
     *
     * @param text EditText à setter
     * @return View.OnClickListener
     */
    private View.OnClickListener getAndSetTextDate(final EditText text, final boolean depart) {
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
                        String day = dayOfMonth < 10 ? "0" + (dayOfMonth) : (dayOfMonth) + "";
                        c.set(year, monthOfYear, dayOfMonth);
                        text.setText(day + "-" + month + "-" + year);
                        if (depart) {
                            dateDepart = c.getTime();
                        } else {
                            dateArrive = c.getTime();
                        }
                    }
                }, mYear, mMonth, mDay);

                setBound(datePickerDialog.getDatePicker(), depart);

                datePickerDialog.show();
            }
        };
    }

    /**
     * Validation for datepicker
     * @param datePicker datepicker
     * @param depart is date for depart
     */
    private void setBound(DatePicker datePicker, boolean depart) {
        final Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, cal.getMinimum(Calendar.HOUR_OF_DAY));
        cal.set(Calendar.MINUTE, cal.getMinimum(Calendar.MINUTE));
        cal.set(Calendar.SECOND, cal.getMinimum(Calendar.SECOND));
        cal.set(Calendar.MILLISECOND, cal.getMinimum(Calendar.MILLISECOND));

        if (depart && dateArrive != null) {
            cal.setTime(this.dateArrive);
            datePicker.setMinDate(cal.getTimeInMillis());
        } else if (!depart && dateDepart != null) {
            cal.setTime(this.dateDepart);
            datePicker.setMaxDate(cal.getTimeInMillis());
        }
    }

    /**
     * Méthode récupérant les heures d'arrivée et départ
     * de l'utilisateur à La Rochelle
     *
     * @param text EditText à setter
     * @return View.OnClickListener
     */
    private View.OnClickListener getAndSetTextTime(final EditText text, final boolean depart) {
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
                        String time;
                        if (depart) {
                            if (timeDepart == null) {
                                timeDepart = new Time();
                            }
                            timeDepart.setHours(hourOfDay);
                            timeDepart.setMinutes(minute);
                            time = timeDepart.toString();
                        } else {
                            if (timeArrive == null) {
                                timeArrive = new Time();
                            }
                            timeArrive.setHours(hourOfDay);
                            timeArrive.setMinutes(minute);
                            time = timeArrive.toString();
                        }
                        text.setText(time);
                    }
                }, mHour, mMinute, true);
                timePickerDialog.show();
            }

        };
    }
    public String getAndroidVersion() {
        return Build.VERSION.RELEASE;
    }
}
