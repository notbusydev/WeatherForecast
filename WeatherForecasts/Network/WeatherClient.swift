//
//  WeatherClient.swift
//  WeatherForecasts
//
//  Created by JaeBin on 2023/05/08.
//

import Foundation
import RxSwift

struct WeatherClient {
    var fetch: (_ cityName: String) -> Observable<WeatherForecastForCityResponse>
}

let apiKey = "717075cbf7ad9b1daf3c178e81f3dd8c"
extension WeatherClient {
    static var live: Self {
        return WeatherClient(fetch: { cityName in
            let urlString = "https://api.openweathermap.org/data/2.5/forecast?appid=\(apiKey)&q=\(cityName)&units=metric"
            guard let url = URL(string: urlString) else { return .error(URLError(.badURL)) }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return URLSession.shared.rx
                .data(request: request)
                .map { data -> WeatherForecastForCityResponse in
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(WeatherForecastForCityResponse.self, from: data)
                    return response
                }
        })
    }
}
