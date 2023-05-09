//
//  TableViewTitleHeaderView.swift
//  WeatherForecasts
//
//  Created by JaeBin on 2023/05/08.
//

import UIKit
import PinLayout
import FlexLayout

class TableViewTitleHeaderView: UITableViewHeaderFooterView {
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.flex.padding(10).define { flex in
            flex.addItem(titleLabel)
        }
        
        contentView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ title: String) {
        titleLabel.text = title
        titleLabel.flex.markDirty()
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    fileprivate func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        return contentView.frame.size
    }
}

