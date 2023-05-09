//
//  WeatherForecastItemTableViewCell.swift
//  WeatherForecasts
//
//  Created by JaeBin on 2023/05/08.
//

import UIKit
import FlexLayout
import PinLayout

class WeatherForecastItemTableViewCell: UITableViewCell {
    
    let iconImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    let mainLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        view.textColor = .darkGray
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 20, weight: .bold)
        return view
    }()
    
    let minTemperatureLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    let maxTemperatureLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    fileprivate func initUI() {
        selectionStyle = .none
        contentView.flex.padding(10).define { flex in
            flex.addItem(dateLabel).marginBottom(10)
            flex.addItem().direction(.row).justifyContent(.spaceBetween).define { flex in
                flex.addItem().define { flex in
                    flex.addItem().direction(.row).define { flex in
                        flex.addItem(iconImageView).size(70).marginRight(10)
                        flex.addItem().justifyContent(.center).define { flex in
                            flex.addItem(mainLabel)
                            flex.addItem(descriptionLabel)
                        }
                    }
                }
                flex.addItem().alignContent(.end).define { flex in
                    flex.addItem(minTemperatureLabel)
                    flex.addItem(maxTemperatureLabel)
                }
            }
        }
    }
    
    fileprivate func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        return contentView.frame.size
    }
    
    func bind(_ item: WeatherForecastItemViewModel) {
        dateLabel.text = item.date
        dateLabel.flex.markDirty()
        iconImageView.image = UIImage(named: item.iconName)
        mainLabel.text = item.main
        mainLabel.flex.markDirty()
        descriptionLabel.text = item.description
        descriptionLabel.flex.markDirty()
        
        minTemperatureLabel.text = item.minTemperature
        minTemperatureLabel.flex.markDirty()
        maxTemperatureLabel.text = item.maxTemperature
        maxTemperatureLabel.flex.markDirty()
        contentView.flex.layout(mode: .adjustHeight)
    }
}
