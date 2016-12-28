//
//  ColorCalendarCollectionViewCell.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 12/26/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import UIKit
import SnapKit



class BaseColorCalendarCollectionViewCell : UICollectionViewCell {
    
    fileprivate lazy var textLabel = UILabel()
    var text:String? {
        set {
            textLabel.text = newValue
        }
        get {
            return textLabel.text
        }
    }
    
    // MARK: UICollectionViewCell methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createUI()
    }
    
    
    // MARK: Private API
    
    fileprivate func createUI() {
        self.addSubview(textLabel)
        self.backgroundColor = UIColor.white
        
        textLabel.snp.makeConstraints { (make) in
            make.center.equalTo(textLabel.superview!)
        }
    }

}

class ColorCalendarCollectionViewCell : BaseColorCalendarCollectionViewCell {
    
    // MARK: internal API
    
    func setAsCurrentMonth() {
        textLabel.textColor = calendarColors.currentMonthDayTextColor
    }
    
    func setAsOtherMonth() {
        textLabel.textColor = calendarColors.otherMonthsDayTextColor
    }
}

class ColorCalendarWeekdaySymbolCollectionViewCell : BaseColorCalendarCollectionViewCell {
    override func createUI() {
        super.createUI()
        textLabel.textColor = calendarColors.weekdaySymbolTextColor
    }
}
