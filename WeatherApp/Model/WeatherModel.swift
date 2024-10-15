//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Florijan Stankir on 09.07.2024..
//

import Foundation

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double?
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let pressure: Int?
    let humidity: Int?
    let sea_level: Int?
    let grnd_level: Int?
}

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct Rain: Codable {
    let oneHour: Double?
    let threeHour: Double?

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHour = "3h"
    }
}

struct Clouds: Codable {
    let all: Int?
}

struct WeatherResponse: Codable {
    let coord: Coordinates
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int?
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds?
    let dt: Int
    let timezone: Int
    let id: Int
    let name: String?
    let cod: Int
}
