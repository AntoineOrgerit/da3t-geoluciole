package com.univlr.geoluciole;

import android.Manifest;
import android.content.Intent;
import android.content.IntentSender;
import android.content.pm.PackageManager;
import android.util.Log;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.CommonStatusCodes;
import com.google.android.gms.common.api.ResolvableApiException;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;
import com.google.android.gms.location.LocationSettingsResponse;
import com.google.android.gms.location.LocationSettingsStatusCodes;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.snackbar.Snackbar;
import com.univlr.geoluciole.permissions.Permission;

import java.util.ArrayList;

public abstract class LocationActivity extends AppCompatActivity {

    private static final String TAG = LocationActivity.class.getSimpleName();

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
        for (final Permission permission : unauthorizedPermissions) {
            Log.w(TAG, "Requesting permission for " + permission.getManifestValue());
            boolean shouldProvideRationale =
                    ActivityCompat.shouldShowRequestPermissionRationale(this,
                            permission.getManifestValue());
            // Provide an additional rationale to the user. This would happen if the user denied the
            // request previously, but didn't check the "Don't ask again" checkbox.
            if (shouldProvideRationale) {
                Log.i(TAG, "Displaying permission rationale to provide additional context.");
                Snackbar.make(
                        findViewById(R.id.main_layout),
                        "Permission",
                        Snackbar.LENGTH_INDEFINITE)
                        .setAction("OK", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                // Request permission
                                ActivityCompat.requestPermissions(LocationActivity.this,
                                        new String[]{permission.getManifestValue()},
                                        permission.getUniqueID());
                            }
                        })
                        .show();
            } else {
                // Request permission. It's possible this can be auto answered if device policy
                // sets the permission in a given state or the user denied the permission
                // previously and checked "Never ask again".
                ActivityCompat.requestPermissions(LocationActivity.this,
                        new String[]{permission.getManifestValue()},
                        permission.getUniqueID());
            }
        }
    }

    protected void enableGPSIfNeeded() {
        LocationRequest locationRequest = LocationRequest.create();
        locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
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
                        case CommonStatusCodes.SUCCESS:
                            onGPSEnabled();
                            break;
                        case CommonStatusCodes.RESOLUTION_REQUIRED:
                            // Location settings are not satisfied. But could be fixed by showing the
                            // user a dialog.
                            try {
                                // Cast to a resolvable exception.
                                ResolvableApiException resolvable = (ResolvableApiException) exception;
                                // Show the dialog by calling startResolutionForResult(),
                                // and check the result in onActivityResult().
                                resolvable.startResolutionForResult(
                                        LocationActivity.this,
                                        LocationRequest.PRIORITY_HIGH_ACCURACY);
                            } catch (IntentSender.SendIntentException | ClassCastException e) {
                                // Ignore, should be an impossible error.
                            }
                            break;
                        case LocationSettingsStatusCodes.SETTINGS_CHANGE_UNAVAILABLE:
                            // Location settings are not satisfied. However, we have no way to fix the
                            // settings so we won't show the dialog.
                            break;
                        default:
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
                    if (permission.getManifestValue() == Manifest.permission.ACCESS_FINE_LOCATION) {
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
        if (requestCode == LocationRequest.PRIORITY_HIGH_ACCURACY) {
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
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    protected abstract void onGPSEnabled();

}
