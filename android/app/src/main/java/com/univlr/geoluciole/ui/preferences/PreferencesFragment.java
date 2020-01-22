package com.univlr.geoluciole.ui.preferences;

import android.app.Dialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Typeface;
import android.net.Uri;
import android.os.Bundle;
import android.text.Html;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProviders;

import com.univlr.geoluciole.CguActivity;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.UserPreferences;

public class PreferencesFragment extends Fragment {
    private static final String MAIL_REVOQUE = "melanie.mondo1@univ-lr.fr";
    public static final String IDENTIFIANT = "ID : ";

    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        PreferencesViewModel preferencesViewModel =
                ViewModelProviders.of(this).get(PreferencesViewModel.class);
        final View root = inflater.inflate(R.layout.fragment_preferences, container, false);
        final UserPreferences userPref = UserPreferences.getInstance(root.getContext());
        String id = userPref.getId();
        if (id != null) {
            TextView id_view = root.findViewById(R.id.id_textview);
            id_view.setText(id);
        }
        Button button = root.findViewById(R.id.button_license_agreement);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(root.getContext(), CguActivity.class));
            }
        });

        Button buttonRevoke = root.findViewById(R.id.button_revoke_consent);
        buttonRevoke.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String line1 = getString(R.string.revoke_text_1);
                String line2 = getString(R.string.revoke_text_2);
                final AlertDialog dialog = new AlertDialog.Builder(root.getContext())
                        .setTitle(R.string.revoke_title)
                        .setMessage(Html.fromHtml(line1 + "<br/>" + "<b>" + MAIL_REVOQUE + "</b>" + "<br/>" + line2))
                        .setNeutralButton(R.string.back, null)
                        .setPositiveButton(R.string.sendMail, null) //Set to null. We override the onclick
                        .setNegativeButton(R.string.copy, null)
                        .create();


                dialog.setOnShowListener(new DialogInterface.OnShowListener() {

                    @Override
                    public void onShow(DialogInterface dialogInterface) {
                        final String id = userPref.getId();
                        Button buttonMail = ((AlertDialog) dialog).getButton(AlertDialog.BUTTON_POSITIVE);
                        Button button = ((AlertDialog) dialog).getButton(AlertDialog.BUTTON_NEGATIVE);
                        Button buttonBack = ((AlertDialog) dialog).getButton(AlertDialog.BUTTON_NEUTRAL);
                        LinearLayout.LayoutParams positiveButtonLL = (LinearLayout.LayoutParams) button.getLayoutParams();
                        positiveButtonLL.gravity = Gravity.CENTER;
                        buttonMail.setLayoutParams(positiveButtonLL);
                        button.setLayoutParams(positiveButtonLL);
                        buttonBack.setLayoutParams(positiveButtonLL);

                        buttonMail.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                Intent send = new Intent(Intent.ACTION_SENDTO);
                                String uriText = "mailto:" + Uri.encode(MAIL_REVOQUE) +
                                        "?subject=" + Uri.encode(getString(R.string.revoke_title)) +
                                        "&body=" + Uri.encode(IDENTIFIANT + id + ". " + getString(R.string.message_mail_revoke));
                                Uri uri = Uri.parse(uriText);
                                send.setData(uri);
                                startActivity(Intent.createChooser(send, getString(R.string.send)));
                            }
                        });

                        button.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                ClipboardManager clipboard = (ClipboardManager) root.getContext().getSystemService(Context.CLIPBOARD_SERVICE);
                                ClipData clip = ClipData.newPlainText(IDENTIFIANT, id);
                                clipboard.setPrimaryClip(clip);
                                Toast.makeText(root.getContext(), R.string.copy_success,
                                        Toast.LENGTH_SHORT).show();
                                //Dismiss once everything is OK.
                                //   dialog.dismiss();
                            }
                        });

                    }
                });
                dialog.show();
            }
        });
        return root;
    }
}