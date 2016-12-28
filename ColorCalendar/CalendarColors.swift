//
//  Color.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 12/28/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import Foundation

public protocol CalendarColors {
    static var currentMonthDayTextColor: UIColor { get }
    static var otherMonthsDayTextColor: UIColor { get }
    static var weekdaySymbolTextColor: UIColor { get }
}


struct DefaultCalendarColors : CalendarColors {

    static var otherMonthsDayTextColor: UIColor {
        get {
            return R.color.defaultColorCalendarPalette.otherMonthsDayTextColor()
        }
    }

    static var currentMonthDayTextColor: UIColor {
        get {
            return R.color.defaultColorCalendarPalette.currentMonthDayTextColor()
        }
    }
    
    static var weekdaySymbolTextColor: UIColor {
        get {
            return R.color.defaultColorCalendarPalette.weekdaySymbolTextColor()
        }
    }
}

var calendarColors = DefaultCalendarColors.self
