//
//  SceneDelegate.swift
//  WeatherForecasts
//
//  Created by JaeBin on 2023/05/08.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        self.window = UIWindow(windowScene: scene)
        let viewModel = WeatherForecastsViewModel()
        let viewController = WeatherForecastsViewController(viewModel: viewModel)
        let rootViewController = UINavigationController(rootViewController: viewController)
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
    }
}

