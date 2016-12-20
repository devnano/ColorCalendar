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
        let previousMonthButton = UIButton(type: .custom)
        let image = UIImage(named: "LeftArrow", in: Bundle(for: type(of:self)), compatibleWith: nil)
        previousMonthButton.setImage(image, for: .normal)
        self.addSubview(previousMonthButton)
        previousMonthButton.snp.makeConstraints{(make) -> Void in
            make.left.top.equalTo(previousMonthButton.superview!)
        }
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
