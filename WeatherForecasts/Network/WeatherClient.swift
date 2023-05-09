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

extension WeatherClient {
    static var live: Self {
        return WeatherClient(fetch: { cityName in
            let host = Constant.apiHost
            var components = URLComponents(string: host)
            components?.path = "/data/2.5/forecast"
            components?.queryItems = [URLQueryItem(name: "appid", value: Constant.apiKey),
                                      URLQueryItem(name: "q", value: cityName),
                                      URLQueryItem(name: "units", value: "metric")]

            guard let url = components?.url else { return .error(URLError(.badURL)) }
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
