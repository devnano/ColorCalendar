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
        
        previousMonthButton.snp.makeConstraints{(make) -> Void in
            make.left.top.equalTo(previousMonthButton.superview!)
        }
        
        nextMonthButton.snp.makeConstraints{(make) -> Void in
            make.right.top.equalTo(nextMonthButton.superview!)
        }
        
        currentMonthLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(previousMonthButton)
            make.centerX.equalTo(currentMonthLabel.superview!)
        }
        
        weekdaysView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(weekdaysView.superview!)
            make.top.equalTo(previousMonthButton.snp.bottom)
        }
    }
}
