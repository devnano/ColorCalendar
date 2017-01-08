//
//  ColorCalendarCollectionViewCell.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 12/26/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import UIKit
import SnapKit



class BaseColorCalendarCollectionViewCell: UICollectionViewCell {
    
    fileprivate lazy var textLabel = UILabel()
    fileprivate lazy var containerView = UIView()
    
    var text:String? {
        set {
            textLabel.text = newValue
        }
        get {
            return textLabel.text
        }
    }
    
    // MARK: - UICollectionViewCell methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createUI()
    }
    
    
    // MARK: - Private API
    
    fileprivate func createUI() {
        addSubview(containerView)
        containerView.addSubview(textLabel)
        
        self.backgroundColor = .white
        containerView.backgroundColor = .white
        
        textLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

class ColorCalendarCollectionViewCell: BaseColorCalendarCollectionViewCell {
    
    // MARK: - internal API
    
    func set(dayColors:DayColors) {
        textLabel.textColor = dayColors.textColor
        containerView.backgroundColor = dayColors.backgroundColor
    }
}

class ColorCalendarWeekdaySymbolCollectionViewCell: BaseColorCalendarCollectionViewCell {
    override func createUI() {
        super.createUI()
        textLabel.textColor = calendarColors.weekdaySymbolTextColor
    }
}
