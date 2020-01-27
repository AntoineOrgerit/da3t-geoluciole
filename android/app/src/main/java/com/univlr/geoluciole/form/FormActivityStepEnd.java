package com.univlr.geoluciole.form;

import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.TimePicker;

import androidx.appcompat.app.AppCompatActivity;

import com.mobsandgeeks.saripaar.Validator;
import com.univlr.geoluciole.MainActivity;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.FormModel;
import com.univlr.geoluciole.model.Time;
import com.univlr.geoluciole.model.UserPreferences;

import java.util.Calendar;
import java.util.Date;

public class FormActivityStepEnd extends AppCompatActivity {
    private static final String TAG = FormActivityStepEnd.class.getSimpleName();
    private static final String STEP_ANONYMOUS = "3/3";
    private static final String FORM = "Form";

    // variable title
    private TextView title;
    // variable step
    private TextView step;

    private Date startDate;
    private Date endDate;
    private Time startTime;
    private Time endTime;

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
        setContentView(R.layout.activity_form_step_end);
        // init éléments du form
        initUI();
        // recuperation de l'objet formulaire
        formSetter();
        // init listeners
        initListenersButtons();
    }

    @Override
    protected void onStart() {
        super.onStart();
        initText();
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
            this.step.setText(STEP_ANONYMOUS);
        }

        // bouton précédent
        this.btnPrevious = (Button) findViewById(R.id.btn_prev);
        // bouton envoi
        this.btnSubmit = (Button) findViewById(R.id.btn_next);

        // bouton
        this.startValidityPeriodBtn = findViewById(R.id.start_validity_period_btn);
        this.endValidityPeriodBtn = findViewById(R.id.end_validity_period_btn);
        // editext
        this.startValidityPeriodEditext = findViewById(R.id.start_validity_period_editText);
        this.endValidityPeriodEditext = findViewById(R.id.end_validity_period_editText);

    }

    private void  initText() {
        this.startValidityPeriodEditext.setText(FormModel.datetimeToString(this.startDate, this.startTime));
        this.endValidityPeriodEditext.setText(FormModel.datetimeToString(this.endDate, this.endTime));
    }

    /**
     * Méthode permettant de gérer le formulaire
     */
    private void formSetter() {
        form = (FormModel) getIntent().getSerializableExtra(FORM);
        Calendar c = Calendar.getInstance();
        // start
        if (form.getDateIn().getTime() < c.getTime().getTime()) {
            this.startDate = c.getTime();
            this.startTime = new Time(8,0);
        } else {
            this.startDate = form.getDateIn();
            this.startTime = form.getTimeIn();
        }
        // end
        if (form.getDateOut().getTime() < c.getTime().getTime()) {
            this.endDate = c.getTime();
            this.endTime = new Time(22,0);
        } else {
            this.endDate = form.getDateOut();
            this.endTime = form.getTimeOut();
        }
    }

    /**
     * Méthode pour ajouter les listeners
     */
    private void initListenersButtons() {
        // bouton précédent
        this.btnPrevious.setOnClickListener(previousView());
        // bouton suivant
        this.btnSubmit.setOnClickListener(finalizeForm());

        // bouton periode
        this.startValidityPeriodBtn.setOnClickListener(onClickListenerStartDatet(true));
        this.startValidityPeriodEditext.setOnClickListener(onClickListenerStartDatet(true));

        // editText periode
        this.endValidityPeriodBtn.setOnClickListener(onClickListenerStartDatet(false));
        this.endValidityPeriodEditext.setOnClickListener(onClickListenerStartDatet(false));
    }

    private View.OnClickListener onClickListenerStartDatet(final boolean start) {
        final Calendar c = Calendar.getInstance();
        if (start) {
            c.setTime(this.startDate);
        } else {
            c.setTime(this.endDate);
        }
        final int mYear = c.get(Calendar.YEAR);
        final int mMonth = c.get(Calendar.MONTH);
        final int mDay = c.get(Calendar.DAY_OF_MONTH);
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                final Calendar c = Calendar.getInstance();
                DatePickerDialog datePickerDialog = new DatePickerDialog(FormActivityStepEnd.this, new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                        String month = monthOfYear < 10 ? "0" + (monthOfYear + 1) : (monthOfYear + 1) + "";
                        String day = dayOfMonth < 10 ? "0" + (dayOfMonth) : (dayOfMonth) + "";
                        c.set(year, monthOfYear, dayOfMonth);
                        if (start) {
                            startDate = c.getTime();
                        } else {
                            endDate = c.getTime();
                        }
                    }
                }, mYear, mMonth, mDay);
                datePickerDialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
                    @Override
                    public void onDismiss(DialogInterface dialogInterface) {
                        openTimer(start);
                    }
                });
                setBound(start, datePickerDialog.getDatePicker());

                datePickerDialog.show();
            }
        };
    }

    private void openTimer(final boolean start) {
        int mMinute;
        int hours;
        if (start) {
            mMinute = this.startTime.getMinutes();
            hours = this.startTime.getHours();
        } else {
            mMinute = this.endTime.getMinutes();
            hours = this.endTime.getHours();
        }
        TimePickerDialog timePickerDialog = new TimePickerDialog(FormActivityStepEnd.this, 0, new TimePickerDialog.OnTimeSetListener() {
            @Override
            public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                if (start) {
                    startTime = new Time(hourOfDay, minute);
                    startValidityPeriodEditext.setText(FormModel.datetimeToString(startDate,startTime));
                } else {
                   endTime = new Time(hourOfDay, minute);
                   endValidityPeriodEditext.setText(FormModel.datetimeToString(endDate, endTime));
                }
            }
        }, hours, mMinute, true);
        timePickerDialog.show();
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

    private void setBound(boolean start, DatePicker picker) {
        if (start) {
            picker.setMinDate(Calendar.getInstance().getTimeInMillis());
        } else {
            picker.setMaxDate(form.getDateOut().getTime());
        }
    }

    /**
     * Méthode permettant de revenir sur la deuxième vue
     */
    private void back() {
        Intent intent = new Intent(getApplicationContext(),
                FormActivityStepThree.class);
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
        back();
    }

    private void savePeriod() {
        UserPreferences userPreferences = UserPreferences.getInstance(this);
        userPreferences.setConsent();
        userPreferences.setPeriodValid(this.startDate, this.startTime, this.endDate, this.endTime);
        userPreferences.store(this);
    }

    /**
     * Méthode récupérant les réponses de l'utilisateur
     * met à jour l'objet formulaire avec les données
     *
     * @return View.OnClickListener
     */
    private View.OnClickListener finalizeForm() {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                savePeriod();
                //todo send http form
                //todo send http compte

                Intent intent = new Intent(FormActivityStepEnd.this, MainActivity.class);

                // on passe l'objet form à la seconde vue
                startActivity(intent);

                // ajout d'une transition type swipe
                overridePendingTransition(R.transition.trans_left_in, R.transition.trans_left_out);
                finish();
            }

        };
    }
}