//
//  ColorCalendarCollectionViewCell.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 12/26/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import UIKit
import SnapKit
import Macaw

class BaseColorCalendarCollectionViewCell: UICollectionViewCell {
    
    var onTapFunc:((BaseColorCalendarCollectionViewCell) -> ())?

    
    fileprivate lazy var containerView: ColorCalendarDayView = {
        let view = ColorCalendarDayView(frame: .zero)
        
        self.addSubview(view)        
        
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        return view
    }()
    
    
    // MARK: - internal API
    
    func set(dayColors:DayColors, font: UIFont? = nil) {
        containerView.dayColors = dayColors
        containerView.font = font
    }
    
    
    func onTap(_ f: @escaping (BaseColorCalendarCollectionViewCell) -> ())  {
        onTapFunc = f
        self.containerView.onTap { (view) in
            f(self)
        }
    }
    
    var text:String? {
        set {
            containerView.text = newValue
        }
        get {
            return containerView.text
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
        self.backgroundColor = CalendarColors.calendarColors.backgroundColor
    }

}

class ColorCalendarCollectionViewCell: BaseColorCalendarCollectionViewCell {

}

class ColorCalendarWeekdaySymbolCollectionViewCell: BaseColorCalendarCollectionViewCell {
}
