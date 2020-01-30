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

package fr.univ_lr.geoluciole.model.form;

import android.content.Context;

import fr.univ_lr.geoluciole.R;
import fr.univ_lr.geoluciole.model.UserPreferences;

public class FormModelWithConsent extends FormModel {
    private String lastname;
    private String firstname;
    private String email;
    private String phone;

    public FormModelWithConsent(String id_user) {
        super(id_user);
    }

    public String getLastname() {
        return lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    public String getFirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    protected String formatAccount(Context context, UserPreferences userPreferences) {
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append(super.formatAccount(context, userPreferences)).append(",");
        stringBuilder.append("\"nom\":").append("\"" + lastname + "\"").append(",");
        stringBuilder.append("\"prenom\":").append("\"" + firstname + "\"").append(",");
        stringBuilder.append("\"mail\":").append("\"" + email + "\"").append(",");
        stringBuilder.append("\"phone\":").append("\"" + phone + "\"").append(",");
        stringBuilder.append("\"consentement_form\":").append("\"" + context.getResources().getString(R.string.rgpd_second_content_consentement) + "\"").append(",");
        stringBuilder.append("\"date_form\":").append(userPreferences.getDateConsentementForm()).append(",");
        stringBuilder.append("\"date_form_str\":").append("\""+FormModel.dateFormatStr(userPreferences.getDateConsentementForm())+"\"");
        return stringBuilder.toString();
    }

    @Override
    public String toString() {
        return super.toString() + "FormModelWithConsent{" +
                "lastname='" + lastname + '\'' +
                ", firstname='" + firstname + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                '}';
    }
}
