package com.univlr.geoluciole.form;

import android.text.Editable;
import android.text.TextWatcher;

import com.mobsandgeeks.saripaar.Validator;


class TextWatcherListener implements TextWatcher {
    private Validator validator;

    public TextWatcherListener(Validator validator) {
        this.validator = validator;
    }

    @Override
    public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

    }

    @Override
    public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

    }

    @Override
    public void afterTextChanged(Editable editable) {
        this.validator.validate();
    }
}
