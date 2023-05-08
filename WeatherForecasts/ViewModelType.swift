//
//  ViewModelType.swift
//  WeatherForecasts
//
//  Created by JaeBin on 2023/05/08.
//

import Foundation
protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
