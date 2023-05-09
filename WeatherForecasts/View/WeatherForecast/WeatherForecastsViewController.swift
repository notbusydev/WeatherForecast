//
//  WeatherForecastsViewController.swift
//  WeatherForecasts
//
//  Created by JaeBin on 2023/05/08.
//

import UIKit

import RxSwift
import RxCocoa
class WeatherForecastsViewController: UIViewController {

    fileprivate let viewModel: WeatherForecastsViewModel
    fileprivate var disposeBag = DisposeBag()
    fileprivate var objects: [WeatherForeCastSectionViewModel] = []
    init(viewModel: WeatherForecastsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    var tableView = UITableView(frame: .zero, style: .grouped)
    
    required init?(coder: NSCoder) { fatalError("init(coder:)") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initBind()
        
    }
    
    func initUI() {
        view.backgroundColor = .white
        tableView.frame = view.bounds
        view.addSubview(tableView)
        tableView.register(WeatherForecastItemTableViewCell.self, forCellReuseIdentifier: "WeatherForecastItemTableViewCell")
        tableView.register(TableViewTitleHeaderView.self, forHeaderFooterViewReuseIdentifier: "TableViewTitleHeaderView")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func initBind() {
        let viewWillAppear = rx.methodInvoked(#selector(self.viewWillAppear(_:)))
            .mapToVoid().asDriverOnErrorJustComplete()
        let input = WeatherForecastsViewModel.Input(viewWillAppear: viewWillAppear)
        let output = viewModel.transform(input: input)
        output.weatherForeCasts
            .drive(weatherForeCastsBinder)
            .disposed(by: disposeBag)
        output.error.drive(errorBinder)
            .disposed(by: disposeBag)
    }
    
    var weatherForeCastsBinder: Binder<[WeatherForeCastSectionViewModel]> {
        Binder(self) { viewController, weatherForeCasts in
            viewController.objects = weatherForeCasts
            viewController.tableView.reloadData()
        }
    }
    
    var errorBinder: Binder<Error> {
        Binder(self) { viewController, error in
            print(error.localizedDescription)
        }
    }
}

extension WeatherForecastsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return objects.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        objects[section].weatherForecastItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherForecastItemTableViewCell", for: indexPath) as! WeatherForecastItemTableViewCell
        let item = objects[indexPath.section].weatherForecastItems[indexPath.row]
        cell.bind(item)
        return cell
    }
}


extension WeatherForecastsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewTitleHeaderView") as! TableViewTitleHeaderView
        header.bind(objects[section].cityName)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
