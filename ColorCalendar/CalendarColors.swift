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
        let colors = DayColors(textColor:DefaultColorCalendarPalette.currentMonthDayTextColor, backgroundColor:DefaultColorCalendarPalette.currentMonthDayBackgroundColor)
        
        return colors
    }

    open func otherMonthsDayColors(forDate date: Date) -> DayColors {
        let colors = DayColors(textColor:DefaultColorCalendarPalette.otherMonthsDayTextColor, backgroundColor:DefaultColorCalendarPalette.otherMonthsDayBackgroundColor)
        
        return colors
    }
    
    open var weekdaySymbolColor: DayColors {
        let colors = DayColors(textColor: DefaultColorCalendarPalette.weekdaySymbolTextColor, backgroundColor: DefaultColorCalendarPalette.weekdaySymbolBackgroundColor)
        
        return colors
    }
    
    open var monthSwitcherColor: DayColors {
        return DayColors(textColor: defaultTextColor, backgroundColor: DefaultColorCalendarPalette.monthSwitcherBackgroundColor)
    }
    
    open var backgroundColor: UIColor {
        return DefaultColorCalendarPalette.backgroundColor
    }
    
    open var defaultTextColor: UIColor {
        return DefaultColorCalendarPalette.defaultTextColor
    }
}

