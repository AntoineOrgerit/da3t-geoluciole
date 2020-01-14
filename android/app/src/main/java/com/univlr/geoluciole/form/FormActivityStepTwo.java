package com.univlr.geoluciole.form;

import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.TimePicker;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.solver.widgets.ConstraintAnchor;

import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.FormModel;

import java.util.Calendar;

public class FormActivityStepTwo extends AppCompatActivity {
    // variables dates et heures
    private EditText txtDateArrivee;
    private EditText txtTimeArrivee;
    private EditText txtDateDepart;
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

    FormModel form;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.form_activity_step_two);
        // recuperation de l'objet formulaire
        form = (FormModel) getIntent().getSerializableExtra("Form");
        // init éléments du form
        initUI();
        // desactive les keyboards des inputs
        disableKeyboardOnInputClick();
        // init listeners inputs
        initListenersInput();
        // init listeners boutons
        initListenersButtons();
    }

    private void initUI() {
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
        // bouton envoi
        this.btnContinue = (Button) findViewById(R.id.btn_next);
        // bouton précédent
        this.btnPrevious = (Button) findViewById(R.id.btn_prev);
    }

    private void disableKeyboardOnInputClick() {
        this.txtDateArrivee.setInputType(EditorInfo.TYPE_NULL);
        this.txtTimeArrivee.setInputType(EditorInfo.TYPE_NULL);
        this.txtDateDepart.setInputType(EditorInfo.TYPE_NULL);
        this.txtTimeDepart.setInputType(EditorInfo.TYPE_NULL);
    }

    private void initListenersInput() {
        this.txtDateArrivee.setOnClickListener(getAndSetTextDate(txtDateArrivee));
        this.txtTimeArrivee.setOnClickListener(getAndSetTextTime(txtTimeArrivee));
        this.txtDateDepart.setOnClickListener(getAndSetTextDate(txtDateDepart));
        this.txtTimeDepart.setOnClickListener(getAndSetTextTime(txtTimeDepart));
    }

    // to do
    private View.OnFocusChangeListener getAndSetTextDateFocus(final EditText text) {
        return new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View view, boolean b) {
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
     * Méthode récupérant les données dates et heures d'arrivée et départ de La Rochelle
     * de l'utilisateur, met à jour l'objet formulaire avec les données
     *
     * @return View.OnClickListener
     */
    private View.OnClickListener getDateTimeData() {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                form.setDateIn(String.valueOf(txtDateArrivee.getText()));
                form.setTimeIn(String.valueOf(txtTimeArrivee.getText()));
                form.setDateOut(String.valueOf(txtDateDepart.getText()));
                form.setTimeOut(String.valueOf(txtTimeDepart.getText()));

                Toast.makeText(FormActivityStepTwo.this,
                        "OnClickListener : " +
                                "\nDate arrivée : " + txtDateArrivee.getText() +
                                "\nHeure arrivée : " + txtTimeArrivee.getText() +
                                "\nDate départ : " + txtDateDepart.getText() +
                                "\nHeure départ : " + txtTimeDepart.getText()
                        ,

                        Toast.LENGTH_SHORT).show();

                Intent intent = new Intent(getApplicationContext(),
                        FormActivityStepTwo.class);
                intent.putExtra("Form", form);
                startActivity(intent);
                finish();

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
        Intent intent = new Intent(getApplicationContext(),
                FormActivityStepOne.class);
        intent.putExtra("Form", form);
        startActivity(intent);
        overridePendingTransition(R.transition.trans_right_in, R.transition.trans_right_out);
        finish();
    }

    /**
     * Redéfinition de la méthode onBackPressed
     * afin de revenir sur le premier écran du formulaire
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
