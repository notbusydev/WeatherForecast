//
//  Date+Extension.swift
//  WeatherForecasts
//
//  Created by JaeBin on 2023/05/08.
//

import Foundation

extension Date {
    func toString(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
    
    var toKorean: String {
        if Calendar.current.isDateInToday(self) {
            return "오늘"
        } else if Calendar.current.isDateInTomorrow(self) {
            return "내일"
        } else {
            return self.toString("yy년 MM월 dd일(E)")
        }
    }
}
