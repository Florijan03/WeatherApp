//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Florijan Stankir on 09.07.2024..
//

import Foundation

enum API {
    static let baseURL = "https://api.openweathermap.org/data/2.5"
    static let apiKey = "7def0c039e268f5c8bd0366bbf4537e2"
}

enum Endpoint {
    case weather(latitude: String, longitude: String)
    case cityWeather(cityName: String)
    
    var path: String {
        switch self {
        case .weather(let latitude, let longitude):
            return "/weather?lat=\(latitude)&lon=\(longitude)&appid=\(API.apiKey)&units=metric"
        case .cityWeather(let cityName):
            return "/weather?q=\(cityName)&appid=\(API.apiKey)&units=metric"
        }
    }
    
    var url: URL {
        let urlString = API.baseURL + path
        return URL(string: urlString)!
    }
    
    var httpMethod: String {
        switch self {
        case .weather:
            return "GET"
        case .cityWeather:
            return "GET"
        }
    }
}
