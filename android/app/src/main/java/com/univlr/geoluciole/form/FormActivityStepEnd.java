/*
 * Copyright (c) 2020, La Rochelle Université
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

package com.univlr.geoluciole.form;

import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
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
import com.univlr.geoluciole.sender.HttpProvider;

import java.util.Calendar;
import java.util.Date;

public class FormActivityStepEnd extends AppCompatActivity {
    private static final String TAG = FormActivityStepEnd.class.getSimpleName();
    private static final String STEP_ANONYMOUS = "3/3";
    private static final String FORM = "Form";

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
    private UserPreferences userPreferences;

    // formulaire
    private FormModel form;

    // validation
    ValidationFormListener validatorListener;
    Validator validator;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_form_step_end);
        userPreferences = UserPreferences.getInstance(this);
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
        // variable title
        TextView title = findViewById(R.id.form_title);
        // step
        // variable step
        TextView step = findViewById(R.id.form_step);
        if (!userPreferences.isAccountConsent()) {
            title.setText(R.string.form_title_anonym);
            step.setText(STEP_ANONYMOUS);
        }

        // bouton précédent
        this.btnPrevious = findViewById(R.id.btn_prev);
        // bouton envoi
        this.btnSubmit = findViewById(R.id.btn_next);

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
            this.startTime = new Time(c.get(Calendar.HOUR_OF_DAY),c.get(Calendar.MINUTE));
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
                        c.set(year, monthOfYear, dayOfMonth);
                        if (start) {
                            startDate = c.getTime();
                        } else {
                            endDate = c.getTime();
                        }
                        openTimer(start);
                    }
                }, mYear, mMonth, mDay);
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
            picker.setMinDate(this.startDate.getTime());
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
        userPreferences.setConsent(true);
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

                // sauvegarde du formulaire
                form.storeInstance(FormActivityStepEnd.this);
                // envoi du formulaire
                HttpProvider.sendForm(FormActivityStepEnd.this, form);

                // send http compte
                HttpProvider.sendAccount(FormActivityStepEnd.this, form.getStringAccount(FormActivityStepEnd.this, userPreferences));

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