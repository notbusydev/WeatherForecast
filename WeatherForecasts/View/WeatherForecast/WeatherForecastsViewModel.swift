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
    let weatherForeCastItems: [WeatherForecastItemViewModel]
    init(_ response: WeatherForecastForCityResponse) {
        cityName = response.city.name
        var temp = [Date: [WeatherForecast]]()
        for weatherForecast in response.list {
            let date = weatherForecast.date
            let startDay = Calendar.current.startOfDay(for: date)
            if let array = temp[startDay] {
                temp[startDay] = array + [weatherForecast]
            } else {
                temp[startDay] = [weatherForecast]
            }
        }
        
        weatherForeCastItems = temp.sorted(by: { $0.key < $1.key })
            .map { key, weatherForecasts -> WeatherForecastItemViewModel in
                let temperatures = weatherForecasts.map { $0.temp }
                let minTemperature = "MIN: \(temperatures.min()?.toString ?? "-")℃"
                let maxTemperature = "MAX: \(temperatures.max()?.toString ?? "-")℃"
                let firstWeather = weatherForecasts.first?.weather.first
                let main = firstWeather?.main ?? " - "
                let description = firstWeather?.description ?? " - "
                let iconName = firstWeather?.icon.replacingOccurrences(of: "\\D", with: "", options: .regularExpression) ?? "na"
                let dateString: String
                if Calendar.current.isDateInToday(key) {
                    dateString = "오늘"
                } else if Calendar.current.isDateInTomorrow(key) {
                    dateString = "내일"
                } else {
                    dateString = key.toString("yy년 MM월 dd일(E)")
                }
                return WeatherForecastItemViewModel(main: main, description: description, iconName: iconName, date: dateString, maxTemperature: maxTemperature, minTemperature: minTemperature)
            }
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
