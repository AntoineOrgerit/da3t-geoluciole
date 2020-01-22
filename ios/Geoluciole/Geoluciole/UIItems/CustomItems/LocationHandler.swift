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
        locationManager.distanceFilter = 10 // on doit bouger de 10m pour détecter un changement
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

    /// Appelé lorsque l'on reçoit une nouvelle position GPS
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // on effectue l'insertion uniquement si la valeur n'est pas nil
        guard let location = locations.last else {
            return
        }

        if Constantes.DEBUG {
            print("Location update")
        }

        LocationTable.getInstance().insertQuery([
            LocationTable.ALTITUDE: location.altitude,
            LocationTable.LATITUDE: location.coordinate.latitude,
            LocationTable.LONGITUDE: location.coordinate.longitude,
            LocationTable.TIMESTAMP: Date().timeIntervalSince1970,
            LocationTable.PRECISION: location.horizontalAccuracy, // rayon d'un cercle en m
            LocationTable.VITESSE: location.speed // vitesse en m/s
        ])

        let preferenceUser = UserPrefs.getInstance()

        /*si des données sont déjà sauvegardées, le calcul de distance est effectué
            sinon les coordonnées captées sont sauvegardées */
        if preferenceUser.object(forKey: UserPrefs.KEY_LAST_POINT) == nil {
            preferenceUser.setPrefs(key: UserPrefs.KEY_LAST_POINT, value: [location.coordinate.latitude, location.coordinate.longitude])
        }

        if (preferenceUser.object(forKey: UserPrefs.KEY_DISTANCE) as? Double) == nil {
            preferenceUser.setPrefs(key: UserPrefs.KEY_DISTANCE, value: 0.0)
        }

        if Constantes.DEBUG {
            print("calcul de la distance")
        }

        let previewDist: Double = (preferenceUser.object(forKey: UserPrefs.KEY_DISTANCE) as! Double)

        let coord1 = CLLocation(latitude: (preferenceUser.object(forKey: UserPrefs.KEY_LAST_POINT) as! [CLLocationDegrees])[0], longitude: (preferenceUser.object(forKey: UserPrefs.KEY_LAST_POINT) as! [CLLocationDegrees])[1])

        let coord2 = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        let tempDist = Tools.getDistance(coordonnee1: coord1, coordonnee2: coord2)

        let distance = previewDist + tempDist
        //update of the saved data.
        preferenceUser.setPrefs(key: UserPrefs.KEY_DISTANCE, value: distance)
        preferenceUser.setPrefs(key: UserPrefs.KEY_LAST_POINT, value: [location.coordinate.latitude, location.coordinate.longitude])
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
                print("Status inconnu")
            }
        }
    }
}
