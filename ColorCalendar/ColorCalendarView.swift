//
//  ColorCalendar.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 12/17/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import UIKit
import SnapKit


public class ColorCalendarView:UIView {
    
    // MARK: Properties
    
    // MARK: UIView methods
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createUI()
    }
    
    
    // MARK: Private API
    
    private func createUI() {
        func createButton(with image:UIImage, and accessibilityLabel:String) -> UIButton {
            let button = UIButton(type: .custom)
            button.setImage(image, for:.normal)
            button.accessibilityLabel = accessibilityLabel
            
            return button
        }
        // This is just plain closure practice/learn closure definition and impl. Not really useful at all:
        typealias CreateButtonClosureType = (UIImage, String) -> (UIButton)
        let createButtonClosure : CreateButtonClosureType = {(image, label) -> UIButton in
            return createButton(with: image, and: label)
        }
        let createButtonConstant : CreateButtonClosureType = createButtonClosure
        let previousMonthButton = createButtonConstant(R.image.leftArrow()!, R.string.localizable.buttonPreviousMonthAccessibilityLabel())
        let nextMonthButton = createButtonConstant(R.image.rightArrow()!, R.string.localizable.buttonNextMonthAccessibilityLabel())
        let currentMonthLabel = UILabel()
        let weekdaysView = UIView()
        
        currentMonthLabel.text = R.string.localizable.labelCurrentMonthAccessibilityLabel()
        currentMonthLabel.text = R.string.localizable.labelCurrentMonthAccessibilityLabel()
       
        self.addSubview(previousMonthButton)
        self.addSubview(nextMonthButton)
        self.addSubview(currentMonthLabel)
        self.addSubview(weekdaysView)
        
        previousMonthButton.snp.makeConstraints{(make) in
            make.left.top.equalTo(previousMonthButton.superview!)
        }
        
        nextMonthButton.snp.makeConstraints{(make) in
            make.right.top.equalTo(nextMonthButton.superview!)
        }
        
        currentMonthLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(previousMonthButton)
            make.centerX.equalTo(currentMonthLabel.superview!)
        }
        
        weekdaysView.snp.makeConstraints { (make) in
            make.left.right.equalTo(weekdaysView.superview!)
            make.top.equalTo(previousMonthButton.snp.bottom)
        }
        
        // Add weekdays view
        let weekdaysSymbols = DateFormatter().veryShortWeekdaySymbols!
        var previousWeekdayLabel:UIView?
        
        for symbol in weekdaysSymbols {
            let weekdayLabel = UILabel()
            weekdayLabel.text = symbol
            weekdaysView.addSubview(weekdayLabel)
            weekdayLabel.textAlignment = .center
            
            weekdayLabel.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(weekdayLabel.superview!)
                if let view = previousWeekdayLabel {
                    make.left.equalTo(view.snp.right)
                    make.width.equalTo(view)
                } else {
                    make.left.equalTo(weekdayLabel.superview!)
                }
            })
            
            previousWeekdayLabel = weekdayLabel
        }
        
        if let view = previousWeekdayLabel {
            view.snp.makeConstraints({ (make) in
                make.right.equalTo(view.superview!)
            })
        }
    }
}
