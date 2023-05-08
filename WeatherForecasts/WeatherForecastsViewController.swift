//
//  WeatherForecastsViewController.swift
//  WeatherForecasts
//
//  Created by JaeBin on 2023/05/08.
//

import UIKit

class WeatherForecastsViewController: UIViewController {
    fileprivate let viewModel: WeatherForecastsViewModel
    init(viewModel: WeatherForecastsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}


