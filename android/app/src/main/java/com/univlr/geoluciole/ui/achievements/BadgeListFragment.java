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

package com.univlr.geoluciole.ui.achievements;

import android.content.Context;
import android.graphics.Point;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.Toast;

import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.fragment.app.Fragment;

import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.UserPreferences;
import com.univlr.geoluciole.model.badge.BadgeManager;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link BadgeListFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * create an instance of this fragment.
 */
public class BadgeListFragment extends Fragment {
    private static final String TAG = BadgeListFragment.class.getSimpleName();
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    private static final int NB_BADGE_PER_ROW = 3;
    private static final int IMG_WIDTH = 250;
    private static final int IMG_HEIGHT = 250;
    private static final int MARGIN = 30;
    private static final int PADDING = 40;
    //  private MainActivity context;


    private OnFragmentInteractionListener mListener;
    private Context context;

    public BadgeListFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View root = inflater.inflate(R.layout.fragment_badge_list, container, false);
        this.context = root.getContext();

        TableLayout mTableLayout = (TableLayout) root.findViewById(R.id.table_badges);
        // get instance des preferences user
        UserPreferences userPref = UserPreferences.getInstance(root.getContext());
        // si liste vide, vue sans badges
        ConstraintLayout constraintLayout = root.findViewById(R.id.layout_sticker);
        ScrollView scrollView = root.findViewById(R.id.scroll_badges);
        if (userPref.getListUnlockedBadges() != null && userPref.getListUnlockedBadges().isEmpty()) {
            scrollView.setVisibility(View.GONE);
            constraintLayout.setVisibility(View.VISIBLE);
        } else { // cache la vue scroll si aucun badge debloque
            constraintLayout.setVisibility(View.GONE);
            scrollView.setVisibility(View.VISIBLE);
            // layout de la table
            LinearLayout.LayoutParams tableRowParams = new LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.MATCH_PARENT);

            // init de la premiere row
            TableRow row = new TableRow(root.getContext());
            if(userPref.getListUnlockedBadges() != null){
                // pour chaque badge debloqués dans la liste
                for (int j = 0; j < userPref.getListUnlockedBadges().size(); ++j) {
                    // pour afficher 3 badges par row
                    if (j % NB_BADGE_PER_ROW == 0 && j != 0) {
                        row = new TableRow(root.getContext());
                    }
                    row.setLayoutParams(tableRowParams);
                    // instanciation d'une image view
                    ImageView iv = setImage(root, userPref, j);
                    // ajout de l'image a la row
                    row.addView(iv);
                    // ajout de la row a la table
                    if (j % NB_BADGE_PER_ROW == 0) {
                        mTableLayout.addView(row);
                    }
                }
            }

        }


        return root;
    }

    private ImageView setImage(View root, UserPreferences userPref, int j) {
        ImageView iv = new ImageView(root.getContext());
        // compute width - height
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        Display display = wm.getDefaultDisplay();
        Point size = new Point();
        display.getSize(size);
        int paddingSpace = PADDING * (NB_BADGE_PER_ROW + 1);
        int widthPerItem = (size.x - paddingSpace) / NB_BADGE_PER_ROW;
        // int heightPerItem = (size.y - paddingSpace) / NB_BADGE_PER_ROW;

        // set ressource
        iv.setImageResource(getRessourceImageBadge(userPref.getListUnlockedBadges().get(j)));
        TableRow.LayoutParams layoutParams = new TableRow.LayoutParams(widthPerItem, ViewGroup.LayoutParams.MATCH_PARENT);

        // layoutParams.setMargins(MARGIN, MARGIN, MARGIN, MARGIN);
        iv.setPadding(PADDING, PADDING, PADDING, PADDING);
        iv.setLayoutParams(layoutParams);
        iv.setClickable(true);
        iv.bringToFront();
        iv.setAdjustViewBounds(true);
        //iv.setScaleType(ImageView.ScaleType.FIT_CENTER);
        iv.setOnClickListener(getBadgeInfo(userPref.getListUnlockedBadges().get(j), root.getContext()));
        Log.i(TAG, "setImage, création de l'image - id :" + userPref.getListUnlockedBadges().get(j));
        return iv;
    }


    private View.OnClickListener getBadgeInfo(final String idBadge, final Context context) {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                BadgeManager badgeManager = BadgeManager.getInstance(context);
                if (badgeManager.getArrayBadges().containsKey(idBadge)) {
                    String name = badgeManager.getArrayBadges().get(idBadge).getName();
                    String desc = badgeManager.getArrayBadges().get(idBadge).getDescription();
                    Toast.makeText(view.getContext(),
                            "Badge " + name + " \n" + desc
                            , Toast.LENGTH_LONG).show();
                }
            }
        };
    }

    /**
     * Méthode permettant de récupérer les ressources des images des badges
     * correspondant à un id donné passé en paramètre
     *
     * @param idBadge String id correspondant à un badge
     * @return int reférence vers l'image
     */
    public static int getRessourceImageBadge(String idBadge) {
        switch (idBadge) {
            case "0":
                return R.mipmap.badge_1km;
            case "1":
                return R.mipmap.badge_5km;
            case "2":
                return R.mipmap.badge_10km;
            case "3":
                return R.mipmap.badge_saint_nicolas;
            case "4":
                return R.mipmap.badge_tour_chaine;
            case "5":
                return R.mipmap.badge_tour_lanterne;
            case "6":
                return R.mipmap.badge_eglise_st_sauveur;
            case "7":
                return R.mipmap.badge_grosse_horloge;
            case "8":
                return R.mipmap.no_image;
            case "9":
                return R.mipmap.badge_plage_minimes;
            case "10":
                return R.mipmap.badge_plage_concurrence;
            case "11":
                return R.mipmap.no_image;
            case "12":
                return R.mipmap.no_image;
            case "13":
                return R.mipmap.no_image;
            case "14":
                return R.mipmap.no_image;
            case "15":
                return R.mipmap.no_image;
            default:
                return R.mipmap.no_image;
        }
    }

    public void onButtonPressed(Uri uri) {
        if (mListener != null) {
            mListener.onFragmentInteraction(uri);
        }
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof OnFragmentInteractionListener) {
            mListener = (OnFragmentInteractionListener) context;
        } else {
            throw new RuntimeException(context.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnFragmentInteractionListener {
        void onFragmentInteraction(Uri uri);
    }

}
