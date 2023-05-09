//
//  WeatherForecastsTests.swift
//  WeatherForecastsTests
//
//  Created by JaeBin on 2023/05/08.
//

import XCTest
import RxSwift
import RxBlocking
@testable import WeatherForecasts

final class WeatherForecastsViewModelTests: XCTestCase {

    
    let disposeBag = DisposeBag()
    
    func test_날씨예보_지역_불러오기_순서() throws {
        let weatherMock = WeatherClient { cityName in
            let city = City(id: 0, name: cityName)
            let response = WeatherForecastForCityResponse(cod: "", message: 0, cnt: 0, list: [], city: city)
            return .just(response)
        }
        let cities = ["Seoul", "London", "Chicago"]
        let viewModel = WeatherForecastsViewModel(weatherClient: weatherMock, cityNames: cities)
        let trigger = PublishSubject<Void>()
        let input = WeatherForecastsViewModel.Input(viewWillAppear: trigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.weatherForeCasts.drive().disposed(by: disposeBag)
        trigger.onNext(())
        
        let weatherForeCasts = try output.weatherForeCasts.toBlocking().first()!
        XCTAssertEqual(weatherForeCasts.count, cities.count)
        for (index, city) in cities.enumerated() {
            XCTAssertEqual(weatherForeCasts[index].cityName, city)
        }
        
    }
    
    func test_날씨예보_지역_불러오기_온도() throws {
        let weatherMock = WeatherClient { cityName in
            let city = City(id: 0, name: cityName)
            let temperatures = [WeatherForecast(temp: 10), WeatherForecast(temp: 30),WeatherForecast(temp: 500)]
            
            let response = WeatherForecastForCityResponse(cod: "", message: 0, cnt: 0, list: temperatures, city: city)
            return .just(response)
        }
        let cities = ["Seoul"]
        let viewModel = WeatherForecastsViewModel(weatherClient: weatherMock, cityNames: cities)
        let trigger = PublishSubject<Void>()
        let input = WeatherForecastsViewModel.Input(viewWillAppear: trigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.weatherForeCasts.drive().disposed(by: disposeBag)
        trigger.onNext(())
        
        let item = try output.weatherForeCasts.toBlocking().first()!.first!.weatherForecastItems.first!
        print(item.maxTemperature)
        XCTAssertEqual("MIN: 10.0℃", item.minTemperature)
        XCTAssertEqual("MAX: 500.0℃", item.maxTemperature)
        
    }

    func test_날씨API에러() throws {
        let weatherMock = WeatherClient { cityName in
            return Observable<WeatherForecastForCityResponse>.error(URLError(.badURL))
        }
        let viewModel = WeatherForecastsViewModel(weatherClient: weatherMock, cityNames: [""])
        let trigger = PublishSubject<Void>()
        let input = WeatherForecastsViewModel.Input(viewWillAppear: trigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.error.drive().disposed(by: disposeBag)
        output.weatherForeCasts.drive().disposed(by: disposeBag)
        trigger.onNext(())
        
        let error = try output.error.toBlocking(timeout: 3).first()
        XCTAssertNotNil(error)
    }

}
