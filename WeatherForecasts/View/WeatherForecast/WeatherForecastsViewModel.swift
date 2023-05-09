//
//  WeatherForecastsViewModel.swift
//  WeatherForecasts
//
//  Created by JaeBin on 2023/05/08.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherForecastsViewModel: ViewModelType {
    struct Input {
        let viewWillAppear: Driver<Void>
    }
    
    struct Output {
        let error: Driver<Error>
        let weatherForeCasts: Driver<[WeatherForeCastSectionViewModel]>
    }
    
    fileprivate let cityNames: [String]
    fileprivate let weatherClient: WeatherClient
    fileprivate let errorTracker = ErrorTracker()
    
    init(weatherClient: WeatherClient, cityNames: [String]) {
        self.weatherClient = weatherClient
        self.cityNames = cityNames
    }
    
    func transform(input: Input) -> Output {
        let cityNames = Driver.just(cityNames)
        
        let weatherForeCasts = input.viewWillAppear
            .withLatestFrom(cityNames)
            .flatMap { cityNames in
                let fetches = cityNames.map { cityName in
                    self.weatherClient.fetch(cityName)
                        .map { [WeatherForeCastSectionViewModel($0)] }
                        .startWith([])
                        .trackError(self.errorTracker)
                        .asDriverOnErrorJustComplete()
                }
                return Driver.combineLatest(fetches) { $0.flatMap { $0 } }
            }
        return Output(error: errorTracker.asDriver(), weatherForeCasts: weatherForeCasts)
    }
}


struct WeatherForeCastSectionViewModel {
    let cityName: String
    let weatherForecastItems: [WeatherForecastItemViewModel]
    init(_ response: WeatherForecastForCityResponse) {
        cityName = response.city.name
        var weatherForecastItems: [WeatherForecastItemViewModel] = []
        var currentDateString: String?
        var currentMinTemperature: Double?
        var currentMaxTemperature: Double?
        
        for (index, weatherForecast) in response.list.enumerated() {
            let forecastDateString = weatherForecast.date.toKorean
            if currentDateString == nil || currentDateString == forecastDateString {
                currentMaxTemperature = weatherForecast.temp.getMax(currentMaxTemperature)
                currentMinTemperature = weatherForecast.temp.getMin(currentMinTemperature)
                currentDateString = forecastDateString
            }
            
            if let dateString = currentDateString, dateString != forecastDateString || index == response.list.count - 1 {
                let firstWeather = weatherForecast.weather.first
                let main = firstWeather?.main ?? " - "
                let description = firstWeather?.description ?? " - "
                let iconName = firstWeather?.icon.replacingOccurrences(of: "\\D", with: "", options: .regularExpression) ?? "na"
                let minTemperature = "MIN: \(currentMinTemperature?.toString ?? "-")℃"
                let maxTemperature = "MAX: \(currentMaxTemperature?.toString ?? "-")℃"
                let itemViewModel = WeatherForecastItemViewModel(main: main,
                                                                 description: description,
                                                                 iconName: iconName,
                                                                 date: dateString,
                                                                 maxTemperature: maxTemperature,
                                                                 minTemperature: minTemperature)
                weatherForecastItems.append(itemViewModel)
                currentDateString = nil
                currentMinTemperature = nil
                currentMaxTemperature = nil
            }
        }
        self.weatherForecastItems = weatherForecastItems
    }
}



struct WeatherForecastItemViewModel {
    let main: String
    let description: String
    let iconName: String
    let date: String
    let maxTemperature: String
    let minTemperature: String
}
