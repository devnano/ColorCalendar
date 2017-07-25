//
//  RosterCalendarColors.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 1/4/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import ColorCalendar
import Roster

//protocol RosterAppPalette {
//    static func workShiftDayColor(_: Void) -> UIColor
//    static func workShiftMorningColor(_: Void) -> UIColor
//    static func workShiftEveningColor(_: Void) -> UIColor
//    static func workShiftNightColor(_: Void) -> UIColor
//    static func workShiftFreeColor(_: Void) -> UIColor
//    static func weekdaySymbolTextColor(_: Void) -> UIColor
//    static func currentDayTextColor(_: Void) -> UIColor
//}
//
//extension R.color.workRosterAppPalette: RosterAppPalette {
//}

class RosterCalendarColors: CalendarColors {
    var roster:Roster
//    public static let palette = R.color.rostaKartjubaPalette.self
    public static let palette = R.color.workRosterAppPalette.self
    
    public init(roster:Roster) {
        self.roster = roster
        super.init()        
    }
    
    static func color(with workShift: WorkShift) -> DayColors {
        var dayColors:DayColors!
        var backgroundColor:UIColor?
        
        switch workShift {
        case .day:
            backgroundColor = palette.workShiftDayColor()
            break
        case .morning:
            backgroundColor = palette.workShiftMorningColor()
            break
        case .afternoon:
            backgroundColor = palette.workShiftEveningColor()
            break
        case .night:
            backgroundColor = palette.workShiftNightColor()
            break
        case .free, .empty:
            backgroundColor = palette.workShiftFreeColor()
            break
        }
        
        
        dayColors = DayColors(textColor:RosterCalendarColors.palette.defaultTextColor(), backgroundColor: backgroundColor!)
        
        return dayColors
    }
    
    override public func currentMonthDayColors(forDate date:Date) -> DayColors {
        let workShift = roster.workShift(forDate: date)
        var dayColors = RosterCalendarColors.color(with: workShift)
        
        if roster.isDateCurrentDay(date) {
            dayColors.textColor = RosterCalendarColors.palette.currentDayTextColor()
        }
        
        return dayColors
    }
    
    override public func otherMonthsDayColors(forDate date: Date) -> DayColors {
        let colors = currentMonthDayColors(forDate: date)
        
        return colors.withAlphaComponent(0.05)
    }
    
    override public var weekdaySymbolColor: DayColors {
        let colors = DayColors(textColor: RosterCalendarColors.palette.weekdaySymbolTextColor(), backgroundColor: RosterCalendarColors.palette.weekdaySymbolBackgroundColor())
        
        return colors
    }
    
    override var defaultTextColor: UIColor {
        return RosterCalendarColors.palette.defaultTextColor()
    }
}
