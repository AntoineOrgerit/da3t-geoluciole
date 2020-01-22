package com.univlr.geoluciole.model;

import com.univlr.geoluciole.R;

public class FormModelWithConsent extends FormModel{
    private String lastname;
    private String firstname;
    private String email;

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

    protected String formatAccount(UserPreferences userPreferences) {
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append(super.formatAccount(userPreferences)).append(",");
        stringBuilder.append("\"nom\":").append(lastname).append(",");
        stringBuilder.append("\"prenom\":").append(firstname).append(",");
        stringBuilder.append("\"mail\":").append(email).append(",");
        stringBuilder.append("\"consentement_form\":").append(R.string.rgpd_second_content_consentement).append(",");
        stringBuilder.append("\"date_form\":").append(userPreferences.getDateConsentementForm());
        //todo ajouter le numero de tel
        return stringBuilder.toString();
    }

    @Override
    public String toString() {
        return super.toString() + "FormModelWithConsent{" +
                "lastname='" + lastname + '\'' +
                ", firstname='" + firstname + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}
