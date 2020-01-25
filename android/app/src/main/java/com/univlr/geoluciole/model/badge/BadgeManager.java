package com.univlr.geoluciole.model.badge;

import android.content.Context;
import android.location.Location;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.UserPreferences;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

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
    private Handler handlerFromUI;

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

    /**
     * Méthode pour débloquer les badges en fonction de la position de l'utilisateur
     *
     * @param idBadge
     * @param context
     */
    public void unlockBadgesPlace(String idBadge, Context context) {
        UserPreferences userPref = UserPreferences.getInstance(context);
        // ajout du badge débloqué dans les prefs utilisateur
        userPref.getListUnlockedBadges().add(idBadge);
        // enregistre les badges débloqués
        userPref.store(context);
        if (this.handlerFromUI != null) {
            Message message = this.handlerFromUI.obtainMessage(0, true);
            message.sendToTarget();
        }
        Log.i(TAG, "checkPlaceLocation, BadgePlace unlocked, " + this.hashmapBadges.get(idBadge).getName());
    }

    // TODO
    public void unlockBadgesDistance() {

    }

    public void initHandler(Handler handlerBadge) {
        this.handlerFromUI = handlerBadge;
    }
}
