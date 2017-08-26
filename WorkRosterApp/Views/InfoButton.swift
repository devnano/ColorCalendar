//
//  InfoButton.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 30/06/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit
import ColorCalendar
import AMPopTip

class InfoButton: ColorCalendarDayView {
    
    // TODO: just show a tip view at a time
    fileprivate var tipView: PopTip?
    private var helpText: NSAttributedString
    private var tipViewWindowWidth: CGFloat?
    private static var currentId: Int = 0;
    private let id: Int

    init(helpText: NSAttributedString) {
        self.helpText = helpText
        self.id = InfoButton.currentId
        InfoButton.currentId += 1
        
        super.init(frame: .zero)
        text = "i"
        dayColors = DayColors(textColor: CalendarColors.calendarColors.defaultTextColor, backgroundColor: RosterCalendarColors.palette.workRosterAppBackground())

        self.onTap { (infoButon) in
            var show: Bool = true
            
            if self.tipView != nil {
                self.tipView!.hide()
                show = false
            } else {
                self.showHelp()
            }
            
            Analytics.tapInfoButton(index: self.id, show: show)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShowHide), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShowHide), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    public func showHelp() {
        
        let tip = PopTip()
        let tipColors = CalendarColors.calendarColors.weekdaySymbolColor
        
        tip.shouldDismissOnTap = true
        tip.edgeMargin = 5
        tip.offset = 2
        tip.bubbleOffset = 0
        tip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        tip.bubbleColor = tipColors.backgroundColor
        tip.textColor = tipColors.textColor
        
        tip.dismissHandler = { _ in
            self.tipView = nil
        }
        let window = self.window!
        let frame = window.convert(self.frame, from: self.superview!)
        tip.show(attributedText: helpText, direction: PopTipDirection.up, maxWidth: window.frame.width * 0.8, in: window, from: frame)
        self.tipView = tip
        self.tipViewWindowWidth = window.frame.width
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        // TODO: Macaw view is getting an offet after the parent view is an arranged view on a stack view and it gets hidden and then shown. Workaround to force y being always = 0:
        var tempFrame =  frame
        tempFrame.origin.y = 0
        frame = tempFrame
        super.layoutSubviews()
    }
    
    @objc private func keyboardDidShowHide() {
        self.tipView?.hide()
    }
    
    @objc private func rotated(notification: NSNotification) {
        if self.window?.frame.width == self.tipViewWindowWidth {
            return
        }
        // TODO: show it again in the proper place
        self.tipView?.hide()
    }
    
    override func createFont() -> UIFont {
        let theTextSize = textSize ?? 15
        
        return CalendarFonts.calendarFonts.boldItalicFont(size: theTextSize)
    }
}
