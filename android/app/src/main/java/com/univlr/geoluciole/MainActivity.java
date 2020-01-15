package com.univlr.geoluciole;

import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.location.Location;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;
import android.view.MenuItem;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import androidx.viewpager.widget.ViewPager;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.univlr.geoluciole.adapter.ViewPagerAdapter;
import com.univlr.geoluciole.location.LocationUpdatesService;
import com.univlr.geoluciole.location.Utils;
import com.univlr.geoluciole.model.UserPreferences;
import com.univlr.geoluciole.permissions.Permission;
import com.univlr.geoluciole.ui.achievements.AchievementsFragment;
import com.univlr.geoluciole.ui.home.HomeFragment;
import com.univlr.geoluciole.ui.preferences.PreferencesFragment;

import java.util.ArrayList;

public class MainActivity extends LocationActivity {
    public static final String PREFERENCES = "Saved_Pref";
    private static final String TAG = MainActivity.class.getSimpleName();

    private LocationUpdatesService mService = null;
    private boolean mBound = false;

    // The BroadcastReceiver used to listen from broadcasts from the service.
    private MyReceiver myReceiver;

    // Monitors the state of the connection to the service.
    private final ServiceConnection mServiceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            LocationUpdatesService.LocalBinder binder = (LocationUpdatesService.LocalBinder) service;
            mService = binder.getService();
            mBound = true;

            // checking permissions
            ArrayList<Permission> unauthorizedPermissions = retrieveUnauthorizedPermissions();
            if (!unauthorizedPermissions.isEmpty()) {
                requestPermissions(unauthorizedPermissions);
            } else {
                enableGPSIfNeeded();
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            mService = null;
            mBound = false;
        }
    };

    private BottomNavigationView navView;
    private MenuItem prevMenuItem;
    private ViewPager viewPager;

    private HomeFragment homeFragment;
    private AchievementsFragment dashboardFragment;
    private PreferencesFragment notificationsFragment;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        UserPreferences u = new UserPreferences(false, 123, "FR", this);
        Log.i("ID RETRIEVED ", u.getId());

        // to store an object
        UserPreferences.storeInstance(this, u);
        // to retrive object stored in preference
        u = UserPreferences.getInstance(this);
        Log.i("UserPreferences",u.toString());


        // temporary receiver
        myReceiver = new MyReceiver();

        // UI
        setContentView(R.layout.activity_main);
        navView = findViewById(R.id.nav_view);
        prevMenuItem = null;
        viewPager = findViewById(R.id.viewpager);
        navView.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {
            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem item) {
                switch (item.getItemId()) {
                    case R.id.navigation_home:
                        viewPager.setCurrentItem(0);
                        break;
                    case R.id.navigation_achievements:
                        viewPager.setCurrentItem(1);
                        break;
                    case R.id.navigation_dashboard:
                        viewPager.setCurrentItem(2);
                        break;
                }
                return false;
            }
        });
        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
                // do nothing
            }

            @Override
            public void onPageSelected(int position) {
                if (prevMenuItem != null) {
                    prevMenuItem.setChecked(false);
                } else {
                    navView.getMenu().getItem(0).setChecked(false);
                }
                Log.d(TAG, "onPageSelected: " + position);
                navView.getMenu().getItem(position).setChecked(true);
                prevMenuItem = navView.getMenu().getItem(position);

            }


            @Override
            public void onPageScrollStateChanged(int state) {
                // do nothing
            }
        });

        setupViewPager(viewPager);
    }

    private void setupViewPager(ViewPager viewPager) {
        ViewPagerAdapter adapter = new ViewPagerAdapter(getSupportFragmentManager());
        homeFragment=new HomeFragment();
        dashboardFragment =new AchievementsFragment();
        notificationsFragment = new PreferencesFragment();
        adapter.addFragment(homeFragment);
        adapter.addFragment(dashboardFragment);
        adapter.addFragment(notificationsFragment);
        viewPager.setAdapter(adapter);
    }

    @Override
    protected void onStart() {
        super.onStart();

        // Bind to the service. If the service is in foreground mode, this signals to the service
        // that since this activity is in the foreground, the service can exit foreground mode.
        bindService(new Intent(this, LocationUpdatesService.class), mServiceConnection,
                Context.BIND_AUTO_CREATE);
    }

    @Override
    protected void onResume() {
        super.onResume();
        LocalBroadcastManager.getInstance(this).registerReceiver(myReceiver,
                new IntentFilter(LocationUpdatesService.ACTION_BROADCAST));
    }

    @Override
    protected void onPause() {
        LocalBroadcastManager.getInstance(this).unregisterReceiver(myReceiver);
        super.onPause();
    }

    @Override
    protected void onStop() {
        if (mBound) {
            // Unbind from the service. This signals to the service that this activity is no longer
            // in the foreground, and the service can respond by promoting itself to a foreground
            // service.
            unbindService(mServiceConnection);
            mBound = false;
        }
        super.onStop();
    }

    @Override
    protected void onGPSEnabled() {
        mService.requestLocationUpdates();
    }

    /**
     * Receiver for broadcasts sent by {@link LocationUpdatesService}.
     */
    private class MyReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            Location location = intent.getParcelableExtra(LocationUpdatesService.EXTRA_LOCATION);
            if (location != null) {
                Toast.makeText(MainActivity.this, Utils.getLocationText(location),
                        Toast.LENGTH_SHORT).show();
            }
        }
    }

}


