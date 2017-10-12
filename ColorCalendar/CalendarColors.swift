//
//  Color.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 12/28/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import Foundation

public struct DayColors {
    public var textColor: UIColor
    public var backgroundColor: UIColor
    
    public init(textColor: UIColor, backgroundColor: UIColor) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
    public func withAlphaComponent(_ alphaComponent: CGFloat) -> DayColors{
        return DayColors(textColor: textColor.withAlphaComponent(alphaComponent), backgroundColor: backgroundColor.withAlphaComponent(alphaComponent))
    }
}

public protocol CalendarColorsProvider {
    func currentMonthDayColors(forDate date: Date) -> DayColors
    func otherMonthsDayColors(forDate date: Date) -> DayColors
    var weekdaySymbolColor: DayColors { get }
    var monthSwitcherColor: DayColors { get }
    var backgroundColor: UIColor { get }
    var defaultTextColor: UIColor { get }
}

open class CalendarColors: CalendarColorsProvider {
    public static var calendarColors:CalendarColors = CalendarColors()
    
    public init() { }

    open func currentMonthDayColors(forDate date: Date)  -> DayColors {
        let colors = DayColors(textColor:R.clr.defaultColorCalendarPalette.currentMonthDayTextColor(), backgroundColor:R.clr.defaultColorCalendarPalette.currentMonthDayBackgroundColor())
        
        return colors
    }

    open func otherMonthsDayColors(forDate date: Date) -> DayColors {
        let colors = DayColors(textColor:R.clr.defaultColorCalendarPalette.otherMonthsDayTextColor(), backgroundColor:R.clr.defaultColorCalendarPalette.otherMonthsDayBackgroundColor())
        
        return colors
    }
    
    open var weekdaySymbolColor: DayColors {
        let colors = DayColors(textColor: R.clr.defaultColorCalendarPalette.weekdaySymbolTextColor(), backgroundColor: R.clr.defaultColorCalendarPalette.weekdaySymbolBackgroundColor())
        
        return colors
    }
    
    open var monthSwitcherColor: DayColors {
        return DayColors(textColor: defaultTextColor, backgroundColor: R.clr.defaultColorCalendarPalette.monthSwitcherBackgroundColor())
    }
    
    open var backgroundColor: UIColor {
        return R.clr.defaultColorCalendarPalette.backgroundColor()
    }
    
    open var defaultTextColor: UIColor {
        return R.clr.defaultColorCalendarPalette.defaultTextColor()
    }
}

