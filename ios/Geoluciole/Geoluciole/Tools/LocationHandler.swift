//    Copyright (c) 2020, La Rochelle Université
//    All rights reserved.
//    Redistribution and use in source and binary forms, with or without
//    modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright
//      notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//    * Neither the name of the University of California, Berkeley nor the
//      names of its contributors may be used to endorse or promote products
//      derived from this software without specific prior written permission.
//
//    THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
//    EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//    DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
//    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import Foundation
import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate {

    fileprivate static var INSTANCE: LocationHandler!
    fileprivate var locationManager: CLLocationManager!

    fileprivate override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.distanceFilter = Constantes.DISTANCE_DETECTION // Définit la distance minimale pour détecter un changement
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.pausesLocationUpdatesAutomatically = false
        if #available(iOS 11.0, *) {
            self.locationManager.showsBackgroundLocationIndicator = true
        }
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
    }

    /// Coupe le tracking GPS
    func stopLocationTracking() {
        self.locationManager.stopUpdatingLocation()
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

            // On prend la distance réelle si celle-ci est inférieure ou égale à la distance estimée
            LocationTable.getInstance().insertQuery([
                LocationTable.ALTITUDE: currentLocation.altitude,
                LocationTable.LATITUDE: currentLocation.latitude,
                LocationTable.LONGITUDE: currentLocation.longitude,
                LocationTable.TIMESTAMP: currentLocation.timestamp,
                LocationTable.PRECISION: currentLocation.precision, // rayon d'un cercle en m
                LocationTable.VITESSE: currentLocation.vitesse, // vitesse en m/s,
                LocationTable.DATE: currentLocation.date_str // date au format du serveur
            ])

            self.updateDistanceParcourue(newDistance: distance)

            // on sauvegarde la dernière position si elle semble cohérente
            UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_LAST_POINT, value: currentLocation.toDictionary())
        }
    }

    /// Mise à jour de la distance parcourue
    fileprivate func updateDistanceParcourue(newDistance: Double) {
        // on regarde si on avait une valeur auparavant
        let distanceUserPrefs = UserPrefs.getInstance().object(forKey: UserPrefs.KEY_DISTANCE_TRAVELED)

        // Si on avait une valeur, on incrémente la valeur
        if distanceUserPrefs != nil {
            var distanceParcourue = distanceUserPrefs as! Double
            distanceParcourue += newDistance
            UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_DISTANCE_TRAVELED, value: distanceParcourue)
            // Sinon, on prend la valeur passé en paramètre
        } else {
            UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_DISTANCE_TRAVELED, value: newDistance)
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
        let now = Date()
        let currentLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, altitude: location.altitude, timestamp: now.timeIntervalSince1970, precision: location.horizontalAccuracy, vitesse: location.speed, date_str: Tools.convertDateToServerDate(date: now))

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
                    LocationTable.VITESSE: currentLocation.vitesse, // vitesse en m/s
                    LocationTable.DATE: currentLocation.date_str // date au format du serveur
                ])

                // on sauvegarde la dernière position si elle semble cohérente
                UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_LAST_POINT, value: currentLocation.toDictionary())
            }

            // On redefini les zones pour pas les perdre et on check les badges de distance
            LocationHandler.startTrackingBadges()
            self.checkDistanceBadges()
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
                self.startLocationTracking()
                CustomTimer.getInstance().startTimerLocalisation()
            }
        case CLAuthorizationStatus.denied:
            self.stopLocationTracking()
            CustomTimer.getInstance().stopTimerLocation()

        case CLAuthorizationStatus.notDetermined:
            self.stopLocationTracking()
            CustomTimer.getInstance().stopTimerLocation()
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
                geofenceRegion.notifyOnExit = false
                LocationHandler.getInstance().locationManager.startMonitoring(for: geofenceRegion)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            self.didEnterRegion(forRegion: region)
        }
    }

    fileprivate func didEnterRegion(forRegion region: CLRegion!) {

        var badge: Badge!

        BadgesTable.getInstance().selectQuery([], where: [WhereCondition(onColumn: BadgesTable.ID, withCondition: region.identifier)]) { (success, queryResult, error) in

            if let error = error {
                if Constantes.DEBUG {
                    print("\(#function) ERROR : " + error.localizedDescription)
                }
                return
            }

            if !queryResult.isEmpty {
                badge = Badge(queryResult[0])
            }
        }

        if badge != nil {
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
                NotificationHandler.getInstance().sendBadgeUnlocked(titleMessage: Tools.getTranslate(key: "notification_title"), bodyMessage: badge.description, idNotification: String(badge!.id))
            }
        }
    }

    fileprivate func checkDistanceBadges() {
        var badgeObtained = [Badge]()
        // distance en M
        let distanceTraveledActually = UserPrefs.getInstance().double(forKey: UserPrefs.KEY_DISTANCE_TRAVELED)

        BadgesTable.getInstance().selectQuery([], where: [WhereCondition(onColumn: BadgesTable.TYPE, withCondition: "distance"), WhereCondition(onColumn: BadgesTable.IS_OBTAIN, withCondition: 0)]) { (success, queryResult, error) in

            if let error = error {
                if Constantes.DEBUG {
                    print("\(#function) ERROR : " + error.localizedDescription)
                }
                return
            }

            for object in queryResult {
                let badge = Badge(object)

                if let distance = badge.distance, distanceTraveledActually >= distance {
                    badgeObtained.append(badge)
                }
            }
        }

        // On update la base de données
        for badge in badgeObtained {
            BadgesTable.getInstance().updateQuery(updateConditions: [UpdateConditions(onColumn: BadgesTable.IS_OBTAIN, newValue: true)], where: [WhereCondition(onColumn: BadgesTable.ID, withCondition: badge.id), WhereCondition(onColumn: BadgesTable.IS_OBTAIN, withCondition: 0)]) { success, error in

                if let error = error {
                    if Constantes.DEBUG {
                        print("\(#function) ERROR : " + error.localizedDescription)
                    }
                    return
                }

                UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_LAST_BADGE, value: badge.resource)

                // Send notification
                NotificationHandler.getInstance().sendBadgeUnlocked(titleMessage: Tools.getTranslate(key: "notification_title"), bodyMessage: badge.description, idNotification: String(badge.id))
            }
        }
    }
}
