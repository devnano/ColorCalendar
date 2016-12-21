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
    public override init(frame: CGRect) {
        super.init(frame: frame)
        func createButton(withImageName imageName:String) -> UIButton {
            let button = UIButton(type: .custom)
            let image = UIImage(named:imageName, in:Bundle(for: type(of:self)), compatibleWith: nil)
            button.setImage(image, for:.normal)
            
            return button
        }
        // This is just plain closure practice/learn closure definition and impl. Not really useful at all:
        typealias ClosureType = (String) -> (UIButton)
        
        let createButtonClosure : ClosureType = {(imageName) -> UIButton in
            return createButton(withImageName:imageName)
        }
        let createButtonConstant : (String) -> UIButton = createButtonClosure
        let previousMonthButton = createButtonConstant("LeftArrow")
        let nextMonthButton = createButtonConstant("RightArrow")
        
        
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
    
}
