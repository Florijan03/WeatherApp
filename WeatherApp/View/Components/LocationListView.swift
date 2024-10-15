//
//  LocationListView.swift
//  WeatherApp
//
//  Created by Florijan Stankir on 09.07.2024..
//


import SwiftUI

struct LocationListView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @State private var newCity: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer().frame(height: 50)
            
            Text("Weather Forecasts")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            
            Spacer().frame(height: 15)
            
            HStack {
                TextField("Enter city name", text: $newCity)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    viewModel.addCity(newCity)
                    newCity = ""
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .padding(.trailing)
                        .foregroundColor(.black)
                }
            }
            
            HStack {
                Text("Saved Locations")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                Spacer()
                Button(action: {
                    viewModel.refreshWeatherData()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding(.trailing)
            }
            
            ScrollView {
                VStack {
                    if let currentLocationWeather = viewModel.weatherData {
                        WeatherCard(weather: currentLocationWeather)
                            .onTapGesture {
                                viewModel.router?.showWeatherDetails(from: AnyView(self), with: currentLocationWeather)
                            }
                    }

                    ForEach(viewModel.savedWeatherData, id: \.id) { weather in
                        WeatherCard(weather: weather)
                            .onTapGesture {
                                viewModel.router?.showWeatherDetails(from: AnyView(self), with: weather)
                            }
                    }
                }
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.7)]), startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
    }
}

struct WeatherCard: View {
    let weather: WeatherResponse
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(weather.name ?? "")
                    .font(.title)
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                Spacer()
                Text(String(format: "%.1f", weather.main.temp ?? 0) + " °C")
                    .font(.title)
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            feelsLikeText
            minText
            maxText
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding(.horizontal) // Razmak s lijeve i desne strane
    }
    
    private var feelsLikeText: some View {
        Text("Feels Like: " + String(format: "%.1f", weather.main.feels_like ?? 0) + " °C")
            .foregroundColor(.white)
    }
    
    private var minText: some View {
        Text("Min: " + String(format: "%.1f", weather.main.temp_min ?? 0) + " °C")
            .foregroundColor(.white)
    }
    
    private var maxText: some View {
        Text("Max: " + String(format: "%.1f", weather.main.temp_max ?? 0) + " °C")
            .foregroundColor(.white)
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView(viewModel: WeatherViewModel())
    }
}
