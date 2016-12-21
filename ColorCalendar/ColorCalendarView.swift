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
    
    // MARK: UIView methods
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        func createButton(withImage image:UIImage, accessibilityIdentifier identifier:String) -> UIButton {
            let button = UIButton(type: .custom)
            button.setImage(image, for:.normal)            
            button.accessibilityIdentifier = identifier
            button.accessibilityLabel = identifier
            
            
            return button
        }
        // This is just plain closure practice/learn closure definition and impl. Not really useful at all:
        typealias CreateButtonClosureType = (UIImage, String) -> (UIButton)
        let createButtonClosure : CreateButtonClosureType = {(image, identifier) -> UIButton in
            return createButton(withImage: image, accessibilityIdentifier: identifier)
        }
        let createButtonConstant : CreateButtonClosureType = createButtonClosure
        let previousMonthButton = createButtonConstant(R.image.leftArrow()!, R.string.localizable.buttonPreviousMonth())
        let nextMonthButton = createButtonConstant(R.image.rightArrow()!, R.string.localizable.buttonNextMonth())
        
        
        self.addSubview(previousMonthButton)
        self.addSubview(nextMonthButton)
        previousMonthButton.snp.makeConstraints{(make) -> Void in
            make.left.top.equalTo(previousMonthButton.superview!)
        }

        nextMonthButton.snp.makeConstraints{(make) -> Void in
            make.right.top.equalTo(nextMonthButton.superview!)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isAccessibilityElement:Bool {
        get {
            return true
        }
        set {
            super.isAccessibilityElement = newValue
        }
    }    
}
