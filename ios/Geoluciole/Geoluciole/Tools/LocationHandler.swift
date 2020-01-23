//
//  LocationHandler.swift
//  Geoluciole
//
//  Created by Alexandre BARET on 16/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate {

    fileprivate static var INSTANCE: LocationHandler!
    fileprivate var locationManager: CLLocationManager
    var locationTracked: Bool = false

    fileprivate override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.distanceFilter = Constantes.DISTANCE_DETECTION // Définit la distance minimale pour détecter un changement
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    static func getInstance() -> LocationHandler {
        if INSTANCE == nil {
            INSTANCE = LocationHandler()
        }

        return INSTANCE
    }

    /// Demande l'autorisation d'utiliser la localisation
    func requestLocationAuthorization() {
        return self.locationManager.requestAlwaysAuthorization()
    }

    /// Lance le tracking GPS
    func startLocationTracking() {
        self.locationManager.startUpdatingLocation()
        self.locationTracked = true
    }

    /// Coupe le tracking GPS
    func stopLocationTracking() {
        self.locationManager.stopUpdatingLocation()
        self.locationTracked = false
    }

    /// Vérifie si la localisation peut être utilisée dans l'application
    func locationCanBeUsed() -> Bool {
        var active: Bool = false
        let status = CLLocationManager.authorizationStatus()
        // On vérifie que les autorisations nécessaires sont données au niveau du terminal
        let authorized = (status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse)

        // Vérifie que la collecte est autorisée
        let sendData = UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_SEND_DATA)

        if sendData && authorized {
            active = true
        }

        return active
    }

    /// Calcule la distance entre la position courante et la dernière position connue
    fileprivate func calculateDistance(currentLocation: Location, lastLocation: Location) {
        let currentPos = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let lastPos = CLLocation(latitude: lastLocation.latitude, longitude: lastLocation.longitude)

        // On vérifie d'abord que les points ne sont pas les mêmes
        if (currentPos.coordinate.latitude != lastPos.coordinate.latitude &&
                currentPos.coordinate.longitude != lastPos.coordinate.longitude) {
            if Constantes.DEBUG {
                print("calcul de la distance")
            }

            // calcul de distance entre les deux points
            let distance = currentPos.distance(from: lastPos)

            let distMax = Constantes.DISTANCE_DETECTION * 2

            // Pour que la distance soit acceptable, il faut que cette distance soit inférieur ou égale à la distance
            // max
            if distance <= distMax {
                LocationTable.getInstance().insertQuery([
                    LocationTable.ALTITUDE: currentLocation.altitude,
                    LocationTable.LATITUDE: currentLocation.latitude,
                    LocationTable.LONGITUDE: currentLocation.longitude,
                    LocationTable.TIMESTAMP: currentLocation.timestamp,
                    LocationTable.PRECISION: currentLocation.precision, // rayon d'un cercle en m
                    LocationTable.VITESSE: currentLocation.vitesse // vitesse en m/s
                ])
                
                updateDistanceParcourue(newDistance: distance)

                // on sauvegarde la dernière position si elle semble cohérente
                UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_LAST_POINT, value: currentLocation.toDictionary())
            }
        }
    }

    /// Mise à jour de la distance parcourue
    fileprivate func updateDistanceParcourue(newDistance: Double) {
        // on regarde si on avait une valeur auparavant
        let distanceUserPrefs = UserPrefs.getInstance().object(forKey: UserPrefs.KEY_DISTANCE)

        // Si on avait une valeur, on incrémente la valeur
        if distanceUserPrefs != nil {
            var distanceParcourue = distanceUserPrefs as! Double
            distanceParcourue += newDistance
            UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_DISTANCE, value: distanceParcourue)
            // Sinon, on prend la valeur passé en paramètre
        } else {
            UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_DISTANCE, value: newDistance)
        }
    }

    /// Retourne la dernière localisation de l'utilisateur. Retourne nil si aucune localisation n'est trouvée
    fileprivate func getLastLocation() -> Location? {
        var lastLocation: Location?

        if let lastLocationUserPrefs = UserPrefs.getInstance().object(forKey: UserPrefs.KEY_LAST_POINT) as? [String: Any] {
            lastLocation = Location(lastLocationUserPrefs)
        }

        return lastLocation
    }

    /// Appelé lorsque l'on reçoit une nouvelle position GPS
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // on effectue l'insertion uniquement si la valeur n'est pas nil
        guard let location = locations.last else {
            return
        }

        // Création de l'objet à insérer
        let currentLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, altitude: location.altitude, timestamp: Date().timeIntervalSince1970, precision: location.horizontalAccuracy, vitesse: location.speed)

        let sendData = UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_SEND_DATA)

        // Si la vitesse est négative ou que la collecte des données n'est pas activée,
        // on ne prend pas en compte la localisation
        if currentLocation.vitesse >= 0.0 && sendData {
            if Constantes.DEBUG {
                print("Location update")
            }
            // Avant de calculer la distance, on regarde si on a déja enregistré un point pour lancer le calcul
            // Si on a une ancienne position, on lance le calcul de distance
            if let lastPosition = getLastLocation() {
                calculateDistance(currentLocation: currentLocation, lastLocation: lastPosition)
            // Si on a pas de position plus ancienne, on insert les données
            } else {
                LocationTable.getInstance().insertQuery([
                    LocationTable.ALTITUDE: currentLocation.altitude,
                    LocationTable.LATITUDE: currentLocation.latitude,
                    LocationTable.LONGITUDE: currentLocation.longitude,
                    LocationTable.TIMESTAMP: currentLocation.timestamp,
                    LocationTable.PRECISION: currentLocation.precision, // rayon d'un cercle en m
                    LocationTable.VITESSE: currentLocation.vitesse // vitesse en m/s
                ])
                
                // on sauvegarde la dernière position si elle semble cohérente
                UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_LAST_POINT, value: currentLocation.toDictionary())
            }
        }
    }



    /// Appelé lorsqu'une erreur liée à la localisation est capturée
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let err = error as? CLError {
            switch err {
            case CLError.locationUnknown:
                if Constantes.DEBUG {
                    print("Position inconnue")
                }
            case CLError.denied:
                locationManager.stopUpdatingLocation()
            default:
                if Constantes.DEBUG {
                    print("Erreur inconnue : \(err.localizedDescription)")
                }
            }
        }
    }

    /// Appelé lors d'un changement d'autorisation lié à la localisation
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let sendData = UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_SEND_DATA)

        switch status {
        case CLAuthorizationStatus.authorizedAlways:
            if sendData {
                if !self.locationTracked {
                    self.startLocationTracking()
                    CustomTimer.getInstance().startTimerLocalisation()
                }
            }
        case CLAuthorizationStatus.denied:
            if self.locationTracked {
                self.stopLocationTracking()
                CustomTimer.getInstance().stopTimerLocation()
            }

        case CLAuthorizationStatus.notDetermined:
            if self.locationTracked {
                self.stopLocationTracking()
                CustomTimer.getInstance().stopTimerLocation()
            }
        default:
            if Constantes.DEBUG {
                print("Statut inconnu")
            }
        }
    }

    static func startTrackingBadges() {

        // Récupération des badges qui n'ont pas été obtenu
        BadgesTable.getInstance().selectQuery([], where: [WhereCondition(onColumn: BadgesTable.IS_OBTAIN, withCondition: 0), WhereCondition(onColumn: BadgesTable.TYPE, withCondition: "place")]) { (success, queryResult, error) in

            if let error = error {
                if Constantes.DEBUG {
                    print("\(#function) ERROR : " + error.localizedDescription)
                }
                return
            }

            for object in queryResult {
                let badge = Badge(object)

                // Ici on est sûr d'avoir une latitude et longitude et proximité car c'est une position
                let geofenceRegionCenter = CLLocationCoordinate2DMake(badge.latitude!, badge.longitude!)
                let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: CLLocationDistance(badge.proximity!), identifier: "\(badge.id)")
                geofenceRegion.notifyOnEntry = true
                geofenceRegion.notifyOnExit = true
                LocationHandler.getInstance().locationManager.startMonitoring(for: geofenceRegion)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            self.didEnterOrExitRegion(forRegion: region)
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            self.didEnterOrExitRegion(forRegion: region)
        }
    }

    fileprivate func didEnterOrExitRegion(forRegion region: CLRegion!) {

        var badge: Badge!

        BadgesTable.getInstance().selectQuery([], where: [WhereCondition(onColumn: BadgesTable.ID, withCondition: region.identifier)]) { (success, queryResult, error) in

            if let error = error {
                if Constantes.DEBUG {
                    print("\(#function) ERROR : " + error.localizedDescription)
                }
                return
            }

            badge = Badge(queryResult[0])
        }

        // On update la base de données
        BadgesTable.getInstance().updateQuery(updateConditions: [UpdateConditions(onColumn: BadgesTable.IS_OBTAIN, newValue: true)], where: [WhereCondition(onColumn: BadgesTable.ID, withCondition: badge.id), WhereCondition(onColumn: BadgesTable.IS_OBTAIN, withCondition: 0)]) { success, error in

            if let error = error {
                if Constantes.DEBUG {
                    print("\(#function) ERROR : " + error.localizedDescription)
                }
                return
            }

            // On arrete de suivre la region
            LocationHandler.getInstance().locationManager.stopMonitoring(for: region)
            
            UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_LAST_BADGE, value: badge.resource)

            // Send notification
            NotificationHandler.getInstance().sendBadgeUnlocked(titleMessage: badge.name, bodyMessage: badge.description)
        }
    }
}
