package com.univlr.geoluciole.ui.preferences;

import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.Html;
import android.text.format.DateFormat;
import android.view.Gravity;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.text.Html;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProviders;

import com.univlr.geoluciole.CguActivity;
import com.univlr.geoluciole.PartnerActivity;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.FormModel;
import com.univlr.geoluciole.model.Time;
import com.univlr.geoluciole.model.UserPreferences;
import com.univlr.geoluciole.sender.HttpProvider;

import java.util.Locale;


import java.util.Calendar;
import java.util.Date;

public class PreferencesFragment extends Fragment {
    private static final String LANG_FR = "fr";
    private static final String LANG_EN = "en";

    private static final String MAIL_REVOQUE = "melanie.mondo1@univ-lr.fr";
    public static final String IDENTIFIANT = "ID : ";

    private Context context;

    private Date startDate;
    private Date endDate;
    private Time startTime;
    private Time endTime;

    // UI
    private TextView id_view; // champ identifiant
    private EditText startValidityPeriodEditext; // champ date début
    private EditText endValidityPeriodEditext; // champ date fin
    private Button btnCGUAgreement;
    private Button btnRevokeConsent;

    // Sring
    private String startValidityStr; // champ date début format dd-mm-yyyy hh:mm
    private String endValidityStr; // champ date fin format dd-mm-yyyy hh:mm

    private Handler handler;

    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        PreferencesViewModel preferencesViewModel =
                ViewModelProviders.of(this).get(PreferencesViewModel.class);
        // récupération de la MainActivity
        final View root = inflater.inflate(R.layout.fragment_preferences, container, false);

        // récupération du contexte associé
        this.context = root.getContext();

        // on récupère les préférences enregistrées
        final UserPreferences userPref = UserPreferences.getInstance(context);
        String id = userPref.getId();

        // initialisation des composants ui
        initUI(root);

        // affiche l'identifiant de l'utiisateur
        if (id != null) {
            this.id_view.setText(id);
        }
        String curent_local = Locale.getDefault().getLanguage();
        RadioButton radioButton_english = root.findViewById(R.id.radioButton_english);
        RadioButton radioButton_french = root.findViewById(R.id.radioButton_french);

        if (curent_local.equals(LANG_FR)) {
            radioButton_french.setChecked(true);

        } else {
            radioButton_english.setChecked(true);
        }
        

        // on set les dates avec les éléments enregistrés dans userPref
        updateDateTimeField();

        // initialisation des listeners des champs date
        initDateTimeListeners();

        // initialisation du listener bouton cgu
        initBtnCGUAgreementListener();

        // definition du listener pour le bouton de révocation
        this.btnRevokeConsent.setOnClickListener(customRevokeBtnOnClickListener());
        handler = new Handler(Looper.getMainLooper()) {
            @Override
            public void handleMessage(Message message) {
                switch (message.what) {
                    case HttpProvider.CODE_HANDLER_GPS_COUNT:
                        Toast.makeText(getActivity(), "Send location : " + message.obj, Toast.LENGTH_SHORT).show();
                        break;
                    case HttpProvider.CODE_HANDLER_GPS_ERROR:
                        Toast.makeText(getActivity(), "Error : " + message.obj, Toast.LENGTH_SHORT).show();
                        break;
                }
            }
        };

        Button send_data_btn = root.findViewById(R.id.button_send_data);
        send_data_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                HttpProvider.sendGps(root.getContext(), handler);
            }
        });

        Button buttonPartners = root.findViewById(R.id.button_partners);
        buttonPartners.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(root.getContext(), PartnerActivity.class));
            }
        });
        return root;
    }

    /**
     * Méthode permettant d'initialiser les composants de l'UI
     *
     * @param root View
     */
    private void initUI(View root) {
        this.id_view = root.findViewById(R.id.id_textview);
        this.startValidityPeriodEditext = root.findViewById(R.id.start_validity_period_et);
        this.endValidityPeriodEditext = root.findViewById(R.id.end_validity_period_et);
        this.btnCGUAgreement = root.findViewById(R.id.button_license_agreement);
        this.btnRevokeConsent = root.findViewById(R.id.button_revoke_consent);

    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    //                        DATES
    ///////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Méthode permettant d'initialiser les listeners sur les EditText des dates
     */
    private void initDateTimeListeners() {
        this.startValidityPeriodEditext.setOnClickListener(onClickListenerStartDate(true, this.context));
        this.endValidityPeriodEditext.setOnClickListener(onClickListenerStartDate(false, this.context));
    }

    /**
     * Méthode permettant la mise à jour des champs dates dans la vue
     */
    private void initText() {
        this.startValidityPeriodEditext.setText(this.startValidityStr);
        this.endValidityPeriodEditext.setText(this.endValidityStr);
    }


    /**
     * Méthode permettant de récupérer les dates de validité depuis les préférences
     * utilisateurs et mise à jour dans la vue
     */
    private void updateDateTimeField() {
        UserPreferences userPref = UserPreferences.getInstance(context);
        // récupération des dates format long
        long startValidity = userPref.getStartValidity();
        long endValidity = userPref.getEndValidity();
        // conversion des long en date
        startDate = new Date(startValidity);
        endDate = new Date(endValidity);
        // instanciation calendar
        Calendar c = Calendar.getInstance();
        // on set le calendar avec la date de début (long)
        c.setTimeInMillis(startValidity);
        // instanciation de l'heure de début
        startTime = new Time(c.get(Calendar.HOUR_OF_DAY), Calendar.MINUTE);
        startValidityStr = FormModel.datetimeToString(c);
        // on set le calendar avec la date de fin (long)
        c.setTimeInMillis(endValidity);
        endValidityStr = FormModel.datetimeToString(c);
        // instanciation de l'heure de fin
        endTime = new Time(c.get(Calendar.HOUR_OF_DAY), Calendar.MINUTE);
        // on set les editText
        initText();
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
    //                        CGU
    ///////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Méthode permettant d'initialiser le listener sur le bouton CGU
     */
    private void initBtnCGUAgreementListener() {
        this.btnCGUAgreement.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(context, CguActivity.class));
            }
        });
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    //                        REVOCATION DIALOG - START
    ///////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Méthode permettant de définir la popup de révocation du consentement
     *
     * @return View.OnClickListener
     */
    private View.OnClickListener customRevokeBtnOnClickListener() {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // création de la popup de révocation de consentement
                final AlertDialog dialog = createAlertDialogRevokeConsent();
                // redefinition des listener sur les boutons de la pop up
                dialog.setOnShowListener(customRevokeDialogOnShowListener(dialog));
                // affiche la pop up de révocation
                dialog.show();
            }
        };
    }

    /**
     * Méthode permettant de créer la popop de révocation de consement
     * On set les éléments de la popup
     *
     * @return AlertDialog
     */
    private AlertDialog createAlertDialogRevokeConsent() {
        String revokeText1 = getString(R.string.revoke_text_1);
        String revokeText2 = getString(R.string.revoke_text_2);
        return new AlertDialog.Builder(context)
                .setTitle(R.string.revoke_title)
                .setMessage(Html.fromHtml(revokeText1 + "<br/>" + "<b>" + MAIL_REVOQUE + "</b>" + "<br/>" + revokeText2))
                .setNeutralButton(R.string.back, null)
                .setPositiveButton(R.string.sendMail, null) //Set to null. We override the onclick
                .setNegativeButton(R.string.copy, null)
                .create();
    }

    /**
     * Méthode permettant de définir les listeners des boutons
     * de la popup de révocation de consentement
     *
     * @param dialog AlertDialog
     * @return DialogInterface.OnShowListener
     */
    private DialogInterface.OnShowListener customRevokeDialogOnShowListener(final AlertDialog dialog) {
        return new DialogInterface.OnShowListener() {

            @Override
            public void onShow(DialogInterface dialogInterface) {
                // initialisation des boutons de la popup
                Button buttonMail = dialog.getButton(AlertDialog.BUTTON_POSITIVE);
                Button buttonCopyID = dialog.getButton(AlertDialog.BUTTON_NEGATIVE);
                Button buttonBack = dialog.getButton(AlertDialog.BUTTON_NEUTRAL);
                // définition du layout
                LinearLayout.LayoutParams positiveButtonLL = (LinearLayout.LayoutParams) buttonCopyID.getLayoutParams();
                positiveButtonLL.gravity = Gravity.CENTER;
                // application du layout sur les boutons
                buttonMail.setLayoutParams(positiveButtonLL);
                buttonCopyID.setLayoutParams(positiveButtonLL);
                buttonBack.setLayoutParams(positiveButtonLL);

                // preset du client mail avec les données
                buttonMail.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Intent send = new Intent(Intent.ACTION_SENDTO);
                        String uriText = "mailto:" + Uri.encode(MAIL_REVOQUE) +
                                "?subject=" + Uri.encode(getString(R.string.revoke_title)) +
                                "&body=" + Uri.encode(IDENTIFIANT + id_view.getText() + ". " + getString(R.string.message_mail_revoke));
                        Uri uri = Uri.parse(uriText);
                        send.setData(uri);
                        startActivity(Intent.createChooser(send, getString(R.string.send)));
                    }
                });

                // copie l'identifiant dans le presse papier
                buttonCopyID.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        ClipboardManager clipboard = (ClipboardManager) context.getSystemService(Context.CLIPBOARD_SERVICE);
                        ClipData clip = ClipData.newPlainText(IDENTIFIANT, id_view.getText());
                        if (clipboard != null) {
                            clipboard.setPrimaryClip(clip);
                            // message toast indiquant que l'identifiant a bien été copié
                            Toast.makeText(context, R.string.copy_success,
                                    Toast.LENGTH_SHORT).show();
                        }
                    }
                });

            }
        };
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    //                        REVOCATION DIALOG - END
    ///////////////////////////////////////////////////////////////////////////////////////////////



    private View.OnClickListener onClickListenerStartDate(final boolean start, final Context context) {
        final Calendar c = Calendar.getInstance();
        if (start) {
            System.out.println("onlistener" + this.startDate);
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
                DatePickerDialog datePickerDialog = new DatePickerDialog(context, new DatePickerDialog.OnDateSetListener() {
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
                        openTimer(start, context);
                    }
                });
                setBound(datePickerDialog.getDatePicker());
                datePickerDialog.show();
            }
        };
    }

    private void openTimer(final boolean start, final Context context) {
        int mMinute = 0;
        int hours = 0;
        if (start) {
            mMinute = this.startTime.getMinutes();
            hours = this.startTime.getHours();
        } else {
            mMinute = this.endTime.getMinutes();
            hours = this.endTime.getHours();
        }
        TimePickerDialog timePickerDialog = new TimePickerDialog(context, 0, new TimePickerDialog.OnTimeSetListener() {
            @Override
            public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                if (start) {
                    startTime = new Time(hourOfDay, minute);
                    startValidityPeriodEditext.setText(FormModel.datetimeToString(startDate, startTime));
                    displayAlertDate();
                } else {
                    endTime = new Time(hourOfDay, minute);
                    endValidityPeriodEditext.setText(FormModel.datetimeToString(endDate, endTime));
                    displayAlertDate();
                }
            }
        }, hours, mMinute, true);
        timePickerDialog.show();
    }

    private void setBound(DatePicker picker) {
        picker.setMinDate(Calendar.getInstance().getTimeInMillis());
    }

    private void displayAlertDate() {
        final AlertDialog dialog = new AlertDialog.Builder(context)
                .setTitle(R.string.message_update_date_title)
                .setMessage(R.string.message_update_date)
                .setPositiveButton(R.string.action_validate, null) //Set to null. We override the onclick
                .setNegativeButton(R.string.back, null)
                .create();
        dialog.setOnShowListener(new DialogInterface.OnShowListener() {

            @Override
            public void onShow(DialogInterface dialogInterface) {
                Button buttonValidate = ((AlertDialog) dialog).getButton(AlertDialog.BUTTON_POSITIVE);
                Button buttonBack = ((AlertDialog) dialog).getButton(AlertDialog.BUTTON_NEGATIVE);

                buttonValidate.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        UserPreferences userPref = UserPreferences.getInstance(context);
                        userPref.setPeriodValid(startDate, startTime, endDate, endTime);
                        UserPreferences.storeInstance(context, userPref);
                        dialog.dismiss();
                    }
                });

                buttonBack.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        updateDateTimeField();
                        dialog.dismiss();
                    }
                });


            }
        });
        dialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialogInterface) {
                updateDateTimeField();
            }
        });
        dialog.show();

    }
}