package com.univlr.geoluciole.model.badge;

import android.content.Context;
import android.util.Log;

import com.univlr.geoluciole.model.UserPreferences;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Exemple de formattage du fichier Json contenant les badges
 * {
 * "badgesList": [
 * {
 * "id": 2,
 * "type": "distance",
 * "name": "10 km",
 * "description": "ten_km_description",
 * "resource": "10_km",
 * "distance": 10
 * },
 * {
 * "id": 3,
 * "type": "place",
 * "name": "Tour Saint Nicolas",
 * "description": "tour_saint_nicolas_description",
 * "latitude": 46.155774242053234,
 * "longitude": -1.153366641086827,
 * "resource": "tour_saint_nicolas",
 * "proximity": 25
 * },...
 * ]
 * }
 */

/**
 * Classe permettant de gérer les badges
 */
public class BadgeManager {
    private static final String TAG = BadgeManager.class.getSimpleName();
    // nom du fichier contenant les badges
    private static final String BADGES_JSON = "badges.json";
    // map contenant les badges à débloquer, sont accessibles grâce à leur clé 'id'
    private HashMap<String, Badge> hashmapBadges;
    // instance singleton
    private static BadgeManager badgeInstance;

    /**
     * Constructeur instanciant le tableau de badges à débloquer
     */
    private BadgeManager() {
        this.hashmapBadges = new HashMap<>();
    }

    /**
     * Singleton BadgeManager
     *
     * @return BadgeManager
     */
    public static synchronized BadgeManager getInstance(Context context) {
        if (badgeInstance == null) {
            badgeInstance = new BadgeManager();
            badgeInstance.instanciateObjFromJson(context);
        }
        return badgeInstance;
    }

    /**
     * Méthode pour instancier un badge de type place
     *
     * @param jsonObjectBadge JSONObject représentant l'objet à instancier
     * @return Badge
     */
    private Badge instanciateBadgePlace(JSONObject jsonObjectBadge, Context context) {
        BadgePlace badge = new BadgePlace();
        try {
            badge.setId(jsonObjectBadge.getString(BadgeConstantes.ID));
            badge.setName(jsonObjectBadge.getString(BadgeConstantes.NAME));
            String key = jsonObjectBadge.getString(BadgeConstantes.DESCRIPTION);
            int id = context.getResources().getIdentifier(key, "string", context.getPackageName());
            badge.setDescription(context.getString(id));
            String badgeLatitude = jsonObjectBadge.getString(BadgeConstantes.LATITUDE);
            String badgeLongitude = jsonObjectBadge.getString(BadgeConstantes.LONGITUDE);
            String badgeProximity = jsonObjectBadge.getString(BadgeConstantes.PROXIMITY);
            badge.getLocation().setLatitude(Double.valueOf(badgeLatitude));
            badge.getLocation().setLongitude(Double.valueOf(badgeLongitude));
            badge.setProximity(Double.valueOf(badgeProximity));
        } catch (JSONException e) {
            Log.e(TAG, "instanciateBadgePlace, " + e.getMessage());
        }
        return badge;
    }

    /**
     * Méthode pour instancier un badge de type distance
     *
     * @param jsonObjectBadge JSONObject représentant l'objet à instancier
     * @return Badge
     */
    private Badge instanciateBadgeDistance(JSONObject jsonObjectBadge, Context context) {
        BadgeDistance badge = new BadgeDistance();
        try {
            badge.setId(jsonObjectBadge.getString(BadgeConstantes.ID));
            badge.setName(jsonObjectBadge.getString(BadgeConstantes.NAME));
            String key = jsonObjectBadge.getString(BadgeConstantes.DESCRIPTION);
            int id = context.getResources().getIdentifier(key, "string", context.getPackageName());
            badge.setDescription(context.getString(id));
            badge.setDistance(Double.valueOf(jsonObjectBadge.getString(BadgeConstantes.DISTANCE)));
        } catch (JSONException e) {
            Log.e(TAG, "instanciateBadgeDistance, " + e.getMessage());
        }
        return badge;
    }

    /**
     * Méthode pour charger le fichier json
     *
     * @return String correspondant au fichier json chargé
     */
    private String loadJSONFromAsset(Context context) {
        String json;
        try {
            InputStream is = context.getAssets().open(BADGES_JSON);
            int size = is.available();
            byte[] buffer = new byte[size];
            int count = is.read(buffer);
            Log.i(TAG, "loadJSONFromAsset, " + count + " bytes lus");
            is.close();
            json = new String(buffer, StandardCharsets.UTF_8);
        } catch (IOException ex) {
            Log.e(TAG, "loadJSONFromAsset, " + ex.getMessage());
            return null;
        }
        return json;
    }

    /**
     * Méthode pour instancier les badges à partir du json
     */
    private void instanciateObjFromJson(Context context) {
        Badge badge = null;
        try {
            JSONObject jsonObject = new JSONObject(loadJSONFromAsset(context));
            JSONArray jsonArray = jsonObject.getJSONArray(BadgeConstantes.BADGES_LIST);
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject jsonObjectBadge = jsonArray.getJSONObject(i);
                if (jsonObjectBadge.getString(BadgeConstantes.TYPE).equalsIgnoreCase(BadgeConstantes.PLACE)) {
                    badge = instanciateBadgePlace(jsonObjectBadge, context);
                    Log.i(TAG, "instanciateObjFromJson, BadgePlace instancié - " + badge.getName());
                } else if (jsonObjectBadge.getString(BadgeConstantes.TYPE).equalsIgnoreCase(BadgeConstantes.DISTANCE)) {
                    badge = instanciateBadgeDistance(jsonObjectBadge, context);
                    Log.i(TAG, "instanciateObjFromJson, BadgeDistance instancié - " + badge.getName());
                }
                // ajout des badges initialisés dans la liste
                if (badge != null) {
                    this.hashmapBadges.put(badge.getId(), badge);
                }
            }
        } catch (JSONException e) {
            Log.e(TAG, "instanciateObjFromJson, " + e.getMessage());
        }
    }

    /**
     * Méthode pour afficher les badges instanciés
     */
    public void displayBadgesList() {
        for (Map.Entry<String, Badge> entry : this.hashmapBadges.entrySet()) {
            Log.i(TAG, String.valueOf(entry.getValue()));
        }
    }

    /**
     * Méthode pour récupérer la map de badges instanciés
     *
     * @return HashMap<String, Badge> String: id du badge, Badge associé à la clé
     */
    public Map<String, Badge> getArrayBadges() {
        return hashmapBadges;
    }


    public HashMap<String, Badge> cleanListBadge(Context context) {
        HashMap<String, Badge> hashmapBadgesUnlocked = new HashMap<>();
        UserPreferences userPref = UserPreferences.getInstance(context);
        ArrayList<String> list = (ArrayList) userPref.getListUnlockedBadges();
        for (Map.Entry<String, Badge> entry : this.hashmapBadges.entrySet()) {
            String key = entry.getKey();
            Badge b = entry.getValue();
            if (!list.contains(key)) {
                hashmapBadgesUnlocked.put(key, b);
            }
        }
        return hashmapBadgesUnlocked;
    }

    /**
     * Méthode pour débloquer les badges en fonction de la position de l'utilisateur
     *
     * @param idBadge String id du badge à débloquer
     * @param context Context
     */
    public void unlockBadgesPlace(String idBadge, Context context) {
        UserPreferences userPref = UserPreferences.getInstance(context);
        // ajout du badge débloqué dans les prefs utilisateur
        userPref.getListUnlockedBadges().add(idBadge);
        // enregistre les badges débloqués
        userPref.store(context);
        Log.i(TAG, "checkPlaceLocation, BadgePlace unlocked, " + this.hashmapBadges.get(idBadge).getName());
    }

    public void unlockBadgesDistance() {
        // TODO
    }


}
