package com.univlr.geoluciole.form;

import android.app.Activity;
import android.content.Intent;
import android.view.View;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.mobsandgeeks.saripaar.ValidationError;
import com.mobsandgeeks.saripaar.Validator;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.FormModel;
import com.univlr.geoluciole.model.UserPreferences;
import com.univlr.geoluciole.sender.HttpSender;

import java.util.List;

public class ValidationFormListener implements Validator.ValidationListener {
    private Activity activity;
    private FormModel form;
    private Class dest;
    private boolean redirect;

    public ValidationFormListener(Activity activity, Class dest, FormModel form) {
        this.activity = activity;
        this.form = form;
        this.dest = dest;
        this.redirect = false;
    }

    @Override
    public void onValidationSucceeded() {
        Toast.makeText(this.activity, "Formulaire valide", Toast.LENGTH_SHORT).show();
        if (this.redirect) {
            if (activity.getClass() == FormActivityStepThree.class) {
                UserPreferences userPreferences = UserPreferences.getInstance(this.activity);
                userPreferences.setConsent();
                HttpSender.testForm(this.form);
                //HttpSender.send(ConsentAndCompte)
            }

            Intent intent = new Intent(this.activity, dest);

            // on passe l'objet form à la seconde vue
            intent.putExtra("Form", this.form);
            this.activity.startActivity(intent);

            // ajout d'une transition type swipe
            this.activity.overridePendingTransition(R.transition.trans_left_in, R.transition.trans_left_out);
            this.redirect = false;
            this.activity.finish();
        }
    }

    @Override
    public void onValidationFailed(List<ValidationError> errors) {
        for (ValidationError error : errors) {
            View view = error.getView();
            String message = error.getCollatedErrorMessage(this.activity);

            // Display error messages ;)
            if (view instanceof EditText) {
                ((EditText) view).setError(message);
            } else if (view instanceof RadioButton) {
                ((RadioButton) view).setError(message);
            } else if (view instanceof Spinner) {
                ((TextView) ((Spinner) view).getSelectedView()).setError(message);
            } else {
                Toast.makeText(this.activity, message, Toast.LENGTH_LONG).show();
            }
        }
    }

    public boolean isRedirect() {
        return redirect;
    }

    public void setRedirect(boolean redirect) {
        this.redirect = redirect;
    }
}
