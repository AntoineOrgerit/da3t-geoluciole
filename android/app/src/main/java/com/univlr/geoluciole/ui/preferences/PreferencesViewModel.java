package com.univlr.geoluciole.ui.preferences;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

class PreferencesViewModel extends ViewModel {

    private MutableLiveData<String> mText;

    public PreferencesViewModel() {
        mText = new MutableLiveData<>();
        mText.setValue("This is preferences fragment");
    }

    public LiveData<String> getText() {
        return mText;
    }
}