//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Florijan Stankir on 09.07.2024..
//

import Foundation

typealias completion = (_ response: WeatherResponse?, _ error: Error?) -> Void

protocol WeatherServiceProtocol {
    func getWeather(_ latitude: String, _ longitude: String, completion: @escaping completion)
    func getCityWeather(_ name: String, completion: @escaping completion)
}

struct WeatherService: WeatherServiceProtocol {
    
    func getWeather(_ latitude: String, _ longitude: String, completion: @escaping completion) {
        WebService.request(Endpoint.weather(latitude: latitude, longitude: longitude), responseType: WeatherResponse.self) { result in
            switch result {
            case .success(let weahterResponse):
                completion(weahterResponse, nil)
            case .failure(let error):
                // Handle the error
                print("Error: \(error)")
                completion(nil, nil)
            }
        }
    }
    
    func getCityWeather(_ name: String, completion: @escaping completion) {
        WebService.request(Endpoint.cityWeather(cityName: name), responseType: WeatherResponse.self) { result in
            switch result {
            case .success(let weahterResponse):
                completion(weahterResponse, nil)
            case .failure(let error):
                print("Error: \(error)")
                completion(nil, nil)
            }
        }
    }
}
