package com.univlr.geoluciole.model.badge;

import android.content.Context;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

/**
 * Exemple de formattage du fichier Json contenant les badges
 * {
 * "badgesList": [
 * {
 * "id": 0,
 * "type": "distance",
 * "name": "1 km",
 * "description": "Bravo! Vous venez de parcourir 1km",
 * "distance": 1
 * },
 * {
 * "id": 1,
 * "type": "place",
 * "name": "L'Aquarium",
 * "description": "Bravo! Vous venez de découvrir l'Aquarium",
 * "latitude": 46.153467,
 * "longitude": -1.150615,
 * "proximity": 15
 * }
 * ]
 * }
 */
public class BadgeManager {
    private static final String BADGES_JSON = "badges.json";
    private ArrayList<Badge> arrayBadges;
    private Context context;
    private static BadgeManager badgeInstance;

    /**
     * Constructeur instanciant le tableau de badges à débloquer
     *
     * @param context Context
     */
    private BadgeManager(Context context) {
        this.arrayBadges = new ArrayList<>();
        this.context = context;
    }

    /**
     * Singleton BadgeManager
     *
     * @param context Context
     * @return BadgeManager
     */
    public static synchronized BadgeManager getInstance(Context context) {
        if (badgeInstance == null) {
            badgeInstance = new BadgeManager(context.getApplicationContext());
        }
        return badgeInstance;
    }

    /**
     * Méthode pour instancier un badge de type place
     *
     * @param jsonObjectBadge JSONObject représentant l'objet à instancier
     * @return Badge
     */
    private Badge instanciateBadgePlace(JSONObject jsonObjectBadge) {
        BadgePlace badge = new BadgePlace();
        try {
            badge.setId(jsonObjectBadge.getString(BadgeConstantes.ID));
            badge.setName(jsonObjectBadge.getString(BadgeConstantes.NAME));
            badge.setDescription(jsonObjectBadge.getString(BadgeConstantes.DESCRIPTION));
            String badgeLatitude = jsonObjectBadge.getString(BadgeConstantes.LATITUDE);
            String badgeLongitude = jsonObjectBadge.getString(BadgeConstantes.LONGITUDE);
            String badgeProximity = jsonObjectBadge.getString(BadgeConstantes.PROXIMITY);
            badge.getLocation().setLatitude(Double.valueOf(badgeLatitude));
            badge.getLocation().setLongitude(Double.valueOf(badgeLongitude));
            badge.setProximity(Double.valueOf(badgeProximity));
        } catch (JSONException e) {
            Log.e("BadgeManager", "instanciateBadgePlace, " + e.getMessage());
        }
        return badge;
    }

    /**
     * Méthode pour instancier un badge de type distance
     *
     * @param jsonObjectBadge JSONObject représentant l'objet à instancier
     * @return Badge
     */
    private Badge instanciateBadgeDistance(JSONObject jsonObjectBadge) {
        BadgeDistance badge = new BadgeDistance();
        try {
            badge.setId(jsonObjectBadge.getString(BadgeConstantes.ID));
            badge.setName(jsonObjectBadge.getString(BadgeConstantes.NAME));
            badge.setDescription(jsonObjectBadge.getString(BadgeConstantes.DESCRIPTION));
            badge.setDistance(Double.valueOf(jsonObjectBadge.getString(BadgeConstantes.DISTANCE)));
        } catch (JSONException e) {
            Log.e("BadgeManager", "instanciateBadgeDistance, " + e.getMessage());
        }
        return badge;
    }

    /**
     * Méthode pour charger le fichier json
     *
     * @return String correspondant au fichier json chargé
     */
    private String loadJSONFromAsset() {
        String json;
        try {
            InputStream is = this.context.getAssets().open(BADGES_JSON);
            int size = is.available();
            byte[] buffer = new byte[size];
            int count = is.read(buffer);
            Log.i("BadgeManager", "loadJSONFromAsset, " + count + " bytes lus");
            is.close();
            json = new String(buffer, StandardCharsets.UTF_8);
        } catch (IOException ex) {
            Log.e("BadgeManager", "loadJSONFromAsset, " + ex.getMessage());
            return null;
        }
        return json;
    }

    /**
     * Méthode pour instancier les badges à partir du json
     */
    public void instanciateObjFromJson() {
        Badge badge = null;
        try {
            JSONObject jsonObject = new JSONObject(loadJSONFromAsset());
            JSONArray jsonArray = jsonObject.getJSONArray(BadgeConstantes.BADGES_LIST);
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject jsonObjectBadge = jsonArray.getJSONObject(i);
                if (jsonObjectBadge.getString(BadgeConstantes.TYPE).equalsIgnoreCase(BadgeConstantes.PLACE)) {
                    badge = instanciateBadgePlace(jsonObjectBadge);
                    Log.i("BadgeManager", "instanciateObjFromJson, BadgePlace instancié - " + badge.getName());
                } else if (jsonObjectBadge.getString(BadgeConstantes.TYPE).equalsIgnoreCase(BadgeConstantes.DISTANCE)) {
                    badge = instanciateBadgeDistance(jsonObjectBadge);
                    Log.i("BadgeManager", "instanciateObjFromJson, BadgeDistance instancié - " + badge.getName());
                }
                // ajout des badges initialisés dans la liste
                this.arrayBadges.add(badge);
            }
        } catch (JSONException e) {
            Log.e("BadgeManager", "instanciateObjFromJson," + e.getMessage());
        }
    }

    /**
     * Méthode pour afficher les badges instanciés
     */
    public void displayBadgesList() {
        for (Badge b : this.arrayBadges) {
            Log.i("BadgeManager", String.valueOf(b));
        }
    }

}
