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
        func createButton(with image:UIImage, and accessibilityLabel:String) -> UIButton {
            let button = UIButton(type: .custom)
            button.setImage(image, for:.normal)
            button.accessibilityLabel = accessibilityLabel
            button.isAccessibilityElement = true
            button.accessibilityTraits = UIAccessibilityTraitButton
            
            return button
        }
        // This is just plain closure practice/learn closure definition and impl. Not really useful at all:
        typealias CreateButtonClosureType = (UIImage, String) -> (UIButton)
        let createButtonClosure : CreateButtonClosureType = {(image, label) -> UIButton in
            return createButton(with: image, and: label)
        }
        let createButtonConstant : CreateButtonClosureType = createButtonClosure
        let previousMonthButton = createButtonConstant(R.image.leftArrow()!, R.string.localizable.buttonPreviousMonthAccesibilityLabel())
        let nextMonthButton = createButtonConstant(R.image.rightArrow()!, R.string.localizable.buttonNextMonthAccesibilityLabel())
        
        
        self.addSubview(previousMonthButton)
        self.addSubview(nextMonthButton)
        previousMonthButton.snp.makeConstraints{(make) -> Void in
            make.left.top.equalTo(previousMonthButton.superview!)
        }

        nextMonthButton.snp.makeConstraints{(make) -> Void in
            make.right.top.equalTo(nextMonthButton.superview!)
        }
//        
//        self.isAccessibilityElement = true
//        self.accessibilityLabel = "Calendar"
//        self.accessibilityTraits = UIAccessibilityTraitSummaryElement
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    public override var isAccessibilityElement:Bool {
//        get {
//            return true
//        }
//        set {
//            super.isAccessibilityElement = newValue
//        }
//    }    
}
