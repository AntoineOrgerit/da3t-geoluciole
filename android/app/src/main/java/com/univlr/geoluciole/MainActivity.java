package com.univlr.geoluciole;

import android.os.Bundle;
import android.util.Log;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.univlr.geoluciole.database.LocationTable;
import com.univlr.geoluciole.model.Location;

import androidx.appcompat.app.AppCompatActivity;
import androidx.navigation.NavController;
import androidx.navigation.Navigation;
import androidx.navigation.ui.AppBarConfiguration;
import androidx.navigation.ui.NavigationUI;

import java.util.List;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        BottomNavigationView navView = findViewById(R.id.nav_view);
        // Passing each menu ID as a set of Ids because each
        // menu should be considered as top level destinations.
        AppBarConfiguration appBarConfiguration = new AppBarConfiguration.Builder(
                R.id.navigation_home, R.id.navigation_dashboard, R.id.navigation_notifications)
                .build();
        NavController navController = Navigation.findNavController(this, R.id.nav_host_fragment);
        NavigationUI.setupActionBarWithNavController(this, navController, appBarConfiguration);
        NavigationUI.setupWithNavController(navView, navController);


        // creation LocationDAO
        //   LocationDAO ldao = new LocationDAO(this);

        // creation d une location
        //  Location l = new Location(2299.55, 44.77, 12345, 99.88, 0);
        //  ldao.open();
        //ldao.addLocation(l);
        // ldao.removeAll();
        //  List list = ldao.getAll();
        //    for (Object location : list) {
        //      Location castedLocation = (Location)location;
        //      Log.i("DATA RETRIEVED",castedLocation.toString() );
        // System.out.println(castedLocation.parseToJson()); // put to json array
        //  }
        //  ldao.close();

        LocationTable lt = new LocationTable(this);
        Location l = new Location(199.66, 44.77, 12345, 99.88);
        lt.insert(l);
        List list = lt.getAll();
        for (Object location : list) {
            Location castedLocation = (Location) location;
            Log.i("DATA RETRIEVED", castedLocation.toString());
        }
    }

}
