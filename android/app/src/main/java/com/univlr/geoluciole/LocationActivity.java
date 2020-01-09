package com.univlr.geoluciole;

import android.Manifest;
import android.content.Intent;
import android.content.IntentSender;
import android.content.pm.PackageManager;
import android.location.Location;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.ResolvableApiException;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;
import com.google.android.gms.location.LocationSettingsResponse;
import com.google.android.gms.location.LocationSettingsStatusCodes;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.univlr.geoluciole.permissions.Permission;

import java.util.ArrayList;

public abstract class LocationActivity extends AppCompatActivity {

    private static String TAG = LocationActivity.class.getSimpleName();

    protected ArrayList<Permission> retrieveUnauthorizedPermissions() {
        ArrayList<Permission> unauthorizedPermissions = new ArrayList<>();
        for (Permission permission : Permission.values()) {
            Log.i(TAG, "Checking permission for " + permission.getManifestValue());
            if (ContextCompat.checkSelfPermission(this, permission.getManifestValue())
                    != PackageManager.PERMISSION_GRANTED) {
                Log.w(TAG, permission.getManifestValue() + " currently unauthorized");
                unauthorizedPermissions.add(permission);
            } else {
                Log.i(TAG, permission.getManifestValue() + " already authorized");
            }
        }
        return unauthorizedPermissions;
    }

    protected void requestPermissions(ArrayList<Permission> unauthorizedPermissions) {
        for(Permission permission : unauthorizedPermissions) {
            Log.w(TAG, "Requesting permission for " + permission.getManifestValue());
            ActivityCompat.requestPermissions(this,
                    new String[]{permission.getManifestValue()},
                    permission.getUniqueID());
        }
    }

    protected void enableGPSIfNeeded() {
        LocationRequest locationRequest = LocationRequest.create();
        locationRequest.setPriority(LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY);
        LocationSettingsRequest.Builder builder = new LocationSettingsRequest.Builder()
                .addLocationRequest(locationRequest);
        Task<LocationSettingsResponse> result =
                LocationServices.getSettingsClient(this).checkLocationSettings(builder.build());
        result.addOnCompleteListener(new OnCompleteListener<LocationSettingsResponse>() {
            @Override
            public void onComplete(@NonNull Task<LocationSettingsResponse> task) {
                try {
                    task.getResult(ApiException.class);
                    onGPSEnabled();
                    // All location settings are satisfied. The client can initialize location
                    // requests here.
                } catch (ApiException exception) {
                    switch (exception.getStatusCode()) {
                        case LocationSettingsStatusCodes.SUCCESS:
                            onGPSEnabled();
                            break;
                        case LocationSettingsStatusCodes.RESOLUTION_REQUIRED:
                            // Location settings are not satisfied. But could be fixed by showing the
                            // user a dialog.
                            try {
                                // Cast to a resolvable exception.
                                ResolvableApiException resolvable = (ResolvableApiException) exception;
                                // Show the dialog by calling startResolutionForResult(),
                                // and check the result in onActivityResult().
                                resolvable.startResolutionForResult(
                                        LocationActivity.this,
                                        LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY);
                            } catch (IntentSender.SendIntentException e) {
                                // Ignore the error.
                            } catch (ClassCastException e) {
                                // Ignore, should be an impossible error.
                            }
                            break;
                        case LocationSettingsStatusCodes.SETTINGS_CHANGE_UNAVAILABLE:
                            // Location settings are not satisfied. However, we have no way to fix the
                            // settings so we won't show the dialog.
                            break;
                    }
                }
            }
        });
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           String[] permissions, int[] grantResults) {
        for (Permission permission : Permission.values()) {
            if (permission.getUniqueID() == requestCode) {
                if (grantResults.length <= 0) {
                    // If user interaction was interrupted, the permission request is cancelled and you
                    // receive empty arrays.
                    Log.e(TAG, "User interaction was cancelled for " + permission.getManifestValue());
                } else if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // Permission was granted.
                    Log.i(TAG, "Permission granted for " + permission.getManifestValue());
                    if(permission.getManifestValue() == Manifest.permission.ACCESS_FINE_LOCATION) {
                        enableGPSIfNeeded();
                    }
                } else {
                    // Permission denied.
                }
            }
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case LocationRequest.PRIORITY_HIGH_ACCURACY:
                switch (resultCode) {
                    case AppCompatActivity.RESULT_OK:
                        // All required changes were successfully made
                        Log.i(TAG, "GPS Enabled by user");
                        onGPSEnabled();
                        break;
                    case AppCompatActivity.RESULT_CANCELED:
                        // The user was asked to change settings, but chose not to
                        Log.i(TAG, "User rejected GPS request");
                        break;
                    default:
                        break;
                }
                break;
        }
    }

    protected abstract void onGPSEnabled();

}
