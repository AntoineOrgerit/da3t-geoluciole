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
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import androidx.viewpager.widget.ViewPager;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.univlr.geoluciole.adapter.ViewPagerAdapter;
import com.univlr.geoluciole.location.LocationUpdatesService;
import com.univlr.geoluciole.location.Utils;
import com.univlr.geoluciole.model.FormModel;
import com.univlr.geoluciole.model.badge.BadgeManager;
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
                if(!unauthorizedPermissions.contains(Permission.FINE_LOCATION_PERMISSION)) {
                    enableGPSIfNeeded();
                }
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

    private ViewPagerAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        FormModel form = (FormModel) getIntent().getSerializableExtra("Form");
        System.out.println("Main Activity form retrieved : " + form);

        super.onCreate(savedInstanceState);

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
        adapter = new ViewPagerAdapter(getSupportFragmentManager());
        homeFragment = new HomeFragment();
        dashboardFragment = new AchievementsFragment();
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
        System.out.println("OnResume");
        setupViewPager(viewPager);

    }

    @Override
    protected void onPause() {
        LocalBroadcastManager.getInstance(this).unregisterReceiver(myReceiver);
        super.onPause();
       /* Fragment newFragment = new AchievementsFragment();
        adapter.getmFragmentList().set(1, newFragment);
        adapter.notifyDataSetChanged();*/


        //   FragmentManager fragmentManager = getSupportFragmentManager();
        //  Fragment fragment = adapter.getItem(1);
        //  long id = adapter.getItemId(1);
        // System.out.println("ID3 "+ id);

        // adapter.getmFragmentList().set(1,frg);
//adapter.notifyDataSetChanged();

      /*  FragmentTransaction transaction = fragmentManager.beginTransaction();
        transaction.remove(fragment);
        fragment = new AchievementsFragment();

        transaction.add(R.id.viewpager, fragment);

       // transaction.addToBackStack("");
        transaction.commit();
*/
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
                BadgeManager badgeManager = BadgeManager.getInstance(context);
                badgeManager.unlockBadges(location, context);
            }
        }
    }

    @Override
    protected void onResumeFragments() {
        super.onResumeFragments();
        System.out.println("resumeFragment");
    }

}
