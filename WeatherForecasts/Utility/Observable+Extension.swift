//
//  Observable+Extension.swift
//  WeatherForecasts
//
//  Created by JaeBin on 2023/05/08.
//

import Foundation
import RxSwift
import RxCocoa
extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<Element> {
        return self.catch { _ in
            return .empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
