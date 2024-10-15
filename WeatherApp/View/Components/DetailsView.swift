
//
//  DetailsView.swift
//  WeatherApp
//
//  Created by Florijan Stankir on 09.07.2024.
//

import SwiftUI

struct DetailsView: View {
    let weatherData: WeatherResponse
    @ObservedObject var weatherViewModel = WeatherViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                HeaderView(weatherData: weatherData, getWeatherIcon: weatherViewModel.getWeatherIcon)
                WeatherDetailsView(weatherData: weatherData)
                WindDetailsView(weatherData: weatherData)
                Spacer()
            }
            .padding()
            .foregroundColor(.white)
        }
        .navigationTitle("Weather Details")
    }
}

struct HeaderView: View {
    let weatherData: WeatherResponse
    let getWeatherIcon: (String) -> String

    var body: some View {
        HStack {
            Text(weatherData.name ?? "")
                .font(.largeTitle)
                .bold()
            Spacer()
            Text(String(format: "%.1f", weatherData.main.temp ?? 0) + "°C")
                .font(.largeTitle)
            Image(systemName: getWeatherIcon(weatherData.weather.first?.icon ?? ""))
        }
    }
}

struct WeatherDetailsView: View {
    let weatherData: WeatherResponse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Feels Like: " + String(format: "%.1f", weatherData.main.feels_like ?? 0) + "°C")
                .font(.title)
            Text("Min: " + String(format: "%.1f", weatherData.main.temp_min ?? 0) + "°C")
                .font(.title2)
                .padding(.leading, 10)
            Text("Max: " + String(format: "%.1f", weatherData.main.temp_max ?? 0) + "°C")
                .font(.title2)
                .padding(.leading, 10)
            Text("Rain: " + (weatherData.rain?.oneHour.map { "\($0) mm (1h)" } ?? " - "))
                .font(.title)
            Text("Cloudiness: " + (weatherData.clouds?.all.map { "\($0) %" } ?? "Clear"))
                .font(.title)
            Text("Pressure: " + String(weatherData.main.pressure ?? 0) + " hPa")
                .font(.title)
            Text("Sea Level: " + String(weatherData.main.sea_level ?? 0) + " hPa")
                .font(.title2)
                .padding(.leading, 10)
            Text("Ground Level: " + String(weatherData.main.grnd_level ?? 0) + " hPa")
                .font(.title2)
                .padding(.leading, 10)
            Text("Humidity: " + String(weatherData.main.humidity ?? 0) + "%")
                .font(.title)

        }
    }
}

struct WindDetailsView: View {
    let weatherData: WeatherResponse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Wind:")
                .font(.title)
            VStack(alignment: .leading, spacing: 10) {
                Text("Speed: " + String(format: "%.2f", weatherData.wind.speed ?? 0) + " m/s")
                    .font(.title2)
                Text("Direction: " + String(weatherData.wind.deg ?? 0) + "°")
                    .font(.title2)
                Text("Gust: " + String(format: "%.2f", weatherData.wind.gust ?? 0) + " m/s")
                    .font(.title2)
            }
            .padding(.leading, 10)
        }
    }
}
