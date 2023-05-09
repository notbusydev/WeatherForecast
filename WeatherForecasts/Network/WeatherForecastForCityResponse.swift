//
//  Entries.swift
//  WeatherForecasts
//
//  Created by JaeBin on 2023/05/08.
//

import Foundation

// MARK: - WeatherForecastForCityResponse
struct WeatherForecastForCityResponse: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [WeatherForecast]
    let city: City

    enum CodingKeys: String, CodingKey {
        case cod = "cod"
        case message = "message"
        case cnt = "cnt"
        case list = "list"
        case city = "city"
    }
}

// MARK: - City
struct City: Decodable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}

// MARK: - List
struct WeatherForecast: Decodable {
    let date: Date
    let temp: Double
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case main = "main"
        case weather = "weather"
        case temp = "temp"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dt = try container.decode(Double.self, forKey: .dt)
        date = Date(timeIntervalSince1970: dt)
        weather = try container.decode([Weather].self, forKey: .weather)
        let mainContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .main)
        temp = try mainContainer.decode(Double.self, forKey: .temp)
    }
    
    init(date: Date = Date(), weather: [Weather] = [], temp: Double = 0) {
        self.date = date
        self.weather = weather
        self.temp = temp
    }
}

// MARK: - Weather
struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case description = "description"
        case icon = "icon"
    }
}
