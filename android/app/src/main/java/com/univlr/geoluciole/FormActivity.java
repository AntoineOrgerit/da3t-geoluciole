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
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
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

package com.univlr.geoluciole;

import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TimePicker;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.textfield.TextInputEditText;

import java.util.Calendar;

public class FormActivity extends AppCompatActivity {
    // variables infos générales
    private TextInputEditText lastname;
    private TextInputEditText firstname;
    private TextInputEditText email;

    private Button btnDatePickerArrivee;
    private Button btnTimePickerArrivee;
    private Button btnDatePickerDepart;
    private Button btnTimePickerDepart;

    // variables dates et heures
    private EditText txtDateArrivee;
    private EditText txtTimeArrivee;
    private EditText txtDateDepart;
    private EditText txtTimeDepart;


    private Spinner spinnerWhomList;
    private Spinner spinnerTransportList;

    private Button btnSubmit;

    private int mYear, mMonth, mDay, mHour, mMinute;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.form_activity);

        // infos générales
        lastname = (TextInputEditText) findViewById(R.id.lastname);
        firstname = (TextInputEditText) findViewById(R.id.firstname);
        email = (TextInputEditText) findViewById(R.id.email);

        // date et heure arrivée
        btnDatePickerArrivee = (Button) findViewById(R.id.btn_in_date);
        btnTimePickerArrivee = (Button) findViewById(R.id.btn_in_time);
        txtDateArrivee = (EditText) findViewById(R.id.in_date);
        txtTimeArrivee = (EditText) findViewById(R.id.in_time);

        // date et heure de départ
        btnDatePickerDepart = (Button) findViewById(R.id.btn_out_date);
        btnTimePickerDepart = (Button) findViewById(R.id.btn_out_time);
        txtDateDepart = (EditText) findViewById(R.id.out_date);
        txtTimeDepart = (EditText) findViewById(R.id.out_time);

        // liste déroulante
        spinnerWhomList = (Spinner) findViewById(R.id.spinner_list_whom);
        spinnerTransportList = (Spinner) findViewById(R.id.spinner_list_transport);

        // bouton envoi
        btnSubmit = (Button) findViewById(R.id.btnSubmit);

        // boutons listeners
        /*btnDatePickerArrivee.setOnClickListener(getAndSetTextDate(txtDateArrivee));
        btnTimePickerArrivee.setOnClickListener(getAndSetTextTime(txtTimeArrivee));
        btnDatePickerDepart.setOnClickListener(getAndSetTextDate(txtDateDepart));
        btnTimePickerDepart.setOnClickListener(getAndSetTextTime(txtTimeDepart));*/
        btnSubmit.setOnClickListener(getAllValuesFromForm());

        // listes déroulantes listeners
        spinnerWhomList.setOnItemSelectedListener(CustomOnItemSelectedListener());
        spinnerTransportList.setOnItemSelectedListener(CustomOnItemSelectedListener());
        this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);

      //  txtDateArrivee.setOnTouchListener(otl);


    }

   /* private View.OnTouchListener otl = new View.OnTouchListener() {
        public boolean onTouch (View v, MotionEvent event) {
            final Calendar c = Calendar.getInstance();
            mYear = c.get(Calendar.YEAR);
            mMonth = c.get(Calendar.MONTH);
            mDay = c.get(Calendar.DAY_OF_MONTH);

            DatePickerDialog datePickerDialog = new DatePickerDialog(FormActivity.this, new DatePickerDialog.OnDateSetListener() {
                @Override
                public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                    String month = monthOfYear < 10 ? "0" + (monthOfYear + 1) : (monthOfYear + 1) + "";
                    txtDateArrivee.setText(dayOfMonth + "-" + month + "-" + year);
                }
            }, mYear, mMonth, mDay);
            datePickerDialog.show();
            return true; // the listener has consumed the event
        }
    };*/

    private View.OnClickListener getAllValuesFromForm() {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Toast.makeText(FormActivity.this,
                        "OnClickListener : " +
                                "\nNom : " + lastname.getText() +
                                "\nPrénom : " + firstname.getText() +
                                "\nEmail : " + email.getText() +
                                "\nDate arrivée : " + txtDateArrivee.getText() +
                                "\nHeure arrivée : " + txtTimeArrivee.getText() +
                                "\nDate départ : " + txtDateDepart.getText() +
                                "\nHeure départ : " + txtTimeDepart.getText() +
                                "\nVoyage avec : " + String.valueOf(spinnerWhomList.getSelectedItem()) +
                                "\nTransport : " + String.valueOf(spinnerTransportList.getSelectedItem()),

                        Toast.LENGTH_SHORT).show();
            }

        };
    }

    /*private View.OnClickListener getAndSetTextDate(final EditText text) {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Get Current Date
                final Calendar c = Calendar.getInstance();
                mYear = c.get(Calendar.YEAR);
                mMonth = c.get(Calendar.MONTH);
                mDay = c.get(Calendar.DAY_OF_MONTH);

                DatePickerDialog datePickerDialog = new DatePickerDialog(FormActivity.this, new DatePickerDialog.OnDateSetListener() {
                    @Override
                    public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                        String month = monthOfYear < 10 ? "0" + (monthOfYear + 1) : (monthOfYear + 1) + "";
                        text.setText(dayOfMonth + "-" + month + "-" + year);
                    }
                }, mYear, mMonth, mDay);
                datePickerDialog.show();
            }
        };
    }*/

    /*private View.OnClickListener getAndSetTextTime(final EditText text) {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Get Current Time
                final Calendar c = Calendar.getInstance();
                mHour = c.get(Calendar.HOUR_OF_DAY);
                mMinute = c.get(Calendar.MINUTE);

                // Launch Time Picker Dialog
                TimePickerDialog timePickerDialog = new TimePickerDialog(FormActivity.this, 0, new TimePickerDialog.OnTimeSetListener() {
                    @Override
                    public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                        text.setText(hourOfDay + ":" + minute);
                    }
                }, mHour, mMinute, true);
                timePickerDialog.show();
            }

        };
    }*/


    public AdapterView.OnItemSelectedListener CustomOnItemSelectedListener() {
        return new AdapterView.OnItemSelectedListener() {
            public void onItemSelected(AdapterView<?> parent, View view, int pos, long id) {
                Toast.makeText(FormActivity.this,
                        "OnItemSelectedListener : " + parent.getItemAtPosition(pos).toString(),
                        Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onNothingSelected(AdapterView<?> arg0) {
                // do nothing
            }
        };
    }


}
