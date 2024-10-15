//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Florijan Stankir on 09.07.2024..
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {

    let locationManager: LocationManager = LocationManager()
    @Published var weatherData: WeatherResponse?
    @Published var savedWeatherData: [WeatherResponse] = []
    @Published var isLoading = true
    var router: AppRouterProtocol?

    private var lastCurrentLocation: CLLocation? = nil
    private var webservice: WeatherServiceProtocol!
    private var cancellables = Set<AnyCancellable>()

    init(webservice: WeatherServiceProtocol = WeatherService(), router: AppRouterProtocol? = nil) {
        self.webservice = webservice
        self.router = router
        observeLocationChanges()
    }

    func observeLocationChanges() {
        locationManager.locationReady = { [weak self] in
            self?.locationManager.$userLocation
                .sink { [weak self] location in
                    guard let self = self else { return }

                    if let loc = location {
                        print("Updated Location: \(loc.coordinate.latitude), \(loc.coordinate.longitude)")
                    } else {
                        print("Location is nil")
                    }

                    self.lastCurrentLocation = location
                    self.refreshWeatherData()
                }
                .store(in: &self!.cancellables)
        }
    }

    var temp: Int {
        Int(weatherData?.main.temp ?? 0.0)
    }

    var name: String {
        "\(weatherData?.name ?? "")"
    }

    var conditionId: Int {
        weatherData?.weather.first?.id ?? 0
    }

    var rainVolume: String {
        if let rain = weatherData?.rain {
            if let oneHour = rain.oneHour {
                return "Rain (1h): \(oneHour) mm"
            }
            if let threeHour = rain.threeHour {
                return "Rain (3h): \(threeHour) mm"
            }
        }
        return "No rain"
    }

    var cloudiness: String {
        if let clouds = weatherData?.clouds?.all {
            return "Cloudiness: \(clouds) %"
        }
        return "Clear"
    }

    func getWeatherIcon(_ icon: String) -> String {
        switch icon {
        case "01d":
            return "sun.max.fill"
        case "01n":
            return "moon.fill"
        case "02d":
            return "cloud.sun.fill"
        case "02n":
            return "cloud.moon.fill"
        case "03d", "03n":
            return "cloud.fill"
        case "04d", "04n":
            return "cloud.bolt.fill"
        case "09d", "09n":
            return "cloud.rain.fill"
        case "10d":
            return "cloud.sun.rain.fill"
        case "10n":
            return "cloud.moon.rain.fill"
        case "11d", "11n":
            return "cloud.bolt.rain.fill"
        case "13d", "13n":
            return "snow"
        case "50d", "50n":
            return "cloud.fog.fill"
        default:
            return "cloud.fill"
        }
    }

    func getCurrentLocationWeather() {
        guard let userLocation = lastCurrentLocation else {
            print("No current location available")
            return
        }

        let latitude = String(userLocation.coordinate.latitude)
        let longitude = String(userLocation.coordinate.longitude)

        print("Fetching weather for location: \(latitude), \(longitude)")

        self.isLoading = true
        webservice.getWeather(latitude, longitude) { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.weatherData = nil
                }
                return
            }
            DispatchQueue.main.async {
                self.isLoading = false
                self.weatherData = response
            }
        }
    }

    /// Get weather by City Name
    func getWeather(by cityName: String) {
        self.isLoading = true
        webservice.getCityWeather(cityName) { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.weatherData = nil
                }
                return
            }
            DispatchQueue.main.async {
                self.isLoading = false
                self.savedWeatherData.append(response)
            }
        }
    }

    func addCity(_ city: String) {
        getWeather(by: city)
    }

    func refreshWeatherData() {
        getCurrentLocationWeather()

        for index in savedWeatherData.indices {
            let cityName = savedWeatherData[index].name ?? ""
            self.webservice.getCityWeather(cityName) { [weak self] response, error in
                guard let self = self else { return }
                guard let response = response else { return }
                DispatchQueue.main.async {
                    self.savedWeatherData[index] = response
                }
            }
        }
    }
}
