//
//  ControlItemContainerView.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 30/06/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit
import ColorCalendar
import Macaw
import SnapKit

class ControlItemContainerView: UIStackView {

    private var infoButton: InfoButton
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    internal init(controlView: UIView, label text: String, helpText: NSAttributedString) {
        infoButton = InfoButton(helpText: helpText)
        super.init(frame: .zero)
        let containerView = self
        let label = UILabel()        
        let labelInfoContainerView = UIStackView()
        
        labelInfoContainerView.axis = .horizontal
        labelInfoContainerView.alignment = .center
        
        labelInfoContainerView.addArrangedSubview(label)
        labelInfoContainerView.addArrangedSubview(infoButton)
        
        // TODO: decouple text from CalendarColors color
        label.textColor = CalendarColors.calendarColors.weekdaySymbolColor.backgroundColor
        label.font = CalendarFonts.calendarFonts.boldFont(size: 15)
        
        containerView.axis = .vertical
        containerView.alignment = .center
        label.text = text
        containerView.addArrangedSubview(labelInfoContainerView)
        containerView.addArrangedSubview(controlView)
        
        infoButton.insetsProportion = 0.1
        
        infoButton.snp.makeConstraints { (make) in
            make.height.lessThanOrEqualTo(infoButton.superview!).priority(.high)
            make.height.equalTo(label).offset(CalendarFonts.calendarFonts.adjustSizeByScreenSize(size: 10)).priority(.medium)
            make.width.equalTo(infoButton.snp.height)
        }        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func showHelp() {
        infoButton.showHelp()
    }
}
