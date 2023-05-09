//
//  Double+Extension.swift
//  WeatherForecasts
//
//  Created by JaeBin on 2023/05/08.
//

import Foundation

extension Double {
    var toString: String {
        String(self)
    }
}

extension Comparable {
    
    func getMin(_ value: Self?) -> Self {
        guard let value = value else { return self }
        return min(self, value)
    }
    
    func getMax(_ value: Self?) -> Self {
        guard let value = value else { return self }
        return max(self, value)
    }
}
