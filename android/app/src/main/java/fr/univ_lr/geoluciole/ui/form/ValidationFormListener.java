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

import java.util.List;

import fr.univ_lr.geoluciole.R;
import fr.univ_lr.geoluciole.model.form.FormModel;

class ValidationFormListener implements Validator.ValidationListener {
    private final Activity activity;
    private final FormModel form;
    private final Class dest;
    private boolean redirect;

    public ValidationFormListener(Activity activity, Class dest, FormModel form) {
        this.activity = activity;
        this.form = form;
        this.dest = dest;
        this.redirect = false;
    }

    @Override
    public void onValidationSucceeded() {
        if (this.redirect) {
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
                Toast.makeText(this.activity, message, Toast.LENGTH_LONG).show(); // message validation
            }
        }
    }

    public void setRedirect(boolean redirect) {
        this.redirect = redirect;
    }
}
