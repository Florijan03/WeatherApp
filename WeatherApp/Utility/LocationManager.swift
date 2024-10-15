//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Florijan Stankir on 09.07.2024..
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol {
    var userLocation: CLLocation? { get set }
}

class LocationManager: NSObject, CLLocationManagerDelegate, LocationManagerProtocol, ObservableObject {
    private var locationManager = CLLocationManager()
    var locationReady: (() -> Void)?

    @Published var userLocation: CLLocation?

    override init() {
        super.init()
        setupLocationManager()
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        let authorizationStatus = CLLocationManager.authorizationStatus()

        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else if authorizationStatus == .denied || authorizationStatus == .restricted {
            print("Location services are not enabled. Please enable them in settings.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Error: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            locationReady?()  // Notify that location is ready
        case .denied, .restricted:
            print("Location services are not enabled. Please enable them in settings.")
        default:
            break
        }
    }
}
