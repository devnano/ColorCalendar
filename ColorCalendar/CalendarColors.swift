//
//  Color.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 12/28/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import Foundation

public struct DayColors {
    public var textColor:UIColor
    public var backgroundColor:UIColor
    
    public init(textColor:UIColor, backgroundColor:UIColor) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
    public func withAlphaComponent(_ alphaComponent: CGFloat) -> DayColors{
        return DayColors(textColor: textColor.withAlphaComponent(alphaComponent), backgroundColor: backgroundColor.withAlphaComponent(alphaComponent))
    }
}

public protocol CalendarColors {
    func currentMonthDayColors(forDate date:Date) -> DayColors
    func otherMonthsDayColors(forDate date:Date) -> DayColors
    var weekdaySymbolTextColor: UIColor { get }
    var monthSwitcherBackgroundColor: UIColor { get }
}


open class DefaultCalendarColors: CalendarColors {
    
    public init() { }

    open func currentMonthDayColors(forDate date:Date)  -> DayColors {
        let colors = DayColors(textColor:R.color.defaultColorCalendarPalette.currentMonthDayTextColor(), backgroundColor:R.color.defaultColorCalendarPalette.currentMonthDayBackgroundColor())
        
        return colors
    }

    open func otherMonthsDayColors(forDate date:Date) -> DayColors {
        let colors = DayColors(textColor:R.color.defaultColorCalendarPalette.otherMonthsDayTextColor(), backgroundColor:R.color.defaultColorCalendarPalette.otherMonthsDayBackgroundColor())
        
        return colors
    }
    
    open var weekdaySymbolTextColor: UIColor {
        return R.color.defaultColorCalendarPalette.weekdaySymbolTextColor()
        
    }
    
    open var monthSwitcherBackgroundColor: UIColor {
        return R.color.defaultColorCalendarPalette.monthSwitcherBackgroundColor()        
    }
}

public func setCalendarColors(_ colors:CalendarColors) {
    calendarColors = colors
}
var calendarColors:CalendarColors = DefaultCalendarColors()
