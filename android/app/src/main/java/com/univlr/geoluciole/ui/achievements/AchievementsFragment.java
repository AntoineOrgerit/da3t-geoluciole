package com.univlr.geoluciole.ui.achievements;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;
import androidx.lifecycle.ViewModelProviders;
import androidx.viewpager.widget.ViewPager;

import com.univlr.geoluciole.MainActivity;
import com.univlr.geoluciole.R;

import com.univlr.geoluciole.model.UserPreferences;
import com.univlr.geoluciole.model.badge.BadgeManager;

import java.io.IOException;
import java.io.InputStream;
import java.math.RoundingMode;
import java.text.DecimalFormat;

/**
 * classe AchievementsFragment correspondant à la vue des badges
 */
public class AchievementsFragment extends Fragment implements BadgeListFragment.OnFragmentInteractionListener {
    private static final String TAG = AchievementsFragment.class.getSimpleName();
    private View root;
    private MainActivity context;
    private BadgeListFragment badgeListFragment;
    private OnFragmentInteractionListener mListener;
    
    
    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View root = inflater.inflate(R.layout.fragment_achievements, container, false);
        this.context = (MainActivity) root.getContext();
        updateDistance();
        return root;
    }
    
    
        @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        Fragment childFragment = new BadgeListFragment();
        FragmentTransaction transaction = getChildFragmentManager().beginTransaction();
        transaction.replace(R.id.badgeList_fragment_container, childFragment).commit();
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof OnFragmentInteractionListener) {
            this.mListener = (OnFragmentInteractionListener) context;
        } else {
            throw new RuntimeException(context.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        this.mListener = null;
    }

    @Override
    public void onFragmentInteraction(Uri uri) {

    }

    public interface OnFragmentInteractionListener {
        // TODO: Update argument type and name
        void messageFromParentFragment(Uri uri);
    }
 
    public void updateDistance(){
        UserPreferences userPref = UserPreferences.getInstance(this.root.getContext());
        TextView textView = this.root.findViewById(R.id.distance_value);

        // définition de l'arrondi
        DecimalFormat df = new DecimalFormat("#.##");
        df.setRoundingMode(RoundingMode.HALF_UP);

        String unit = " m";
        float distance = userPref.getDistance();
        if(userPref.getDistance() > 1000){
            distance = distance / 1000;
            unit = " Km";
        }
        String dis = df.format(distance) + unit;
        textView.setText(dis);   
    }
}