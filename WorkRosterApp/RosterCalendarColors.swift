//
//  RosterCalendarColors.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 1/4/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import ColorCalendar
import Roster

class RosterCalendarColors: CalendarColors {
    var roster:Roster
    
    public init(roster:Roster) {
        self.roster = roster
        super.init()        
    }
    
    static func color(with workShift: WorkShift) -> DayColors {
        var dayColors:DayColors!
        var backgroundColor:UIColor?
        
        switch workShift {
        case .day:
            backgroundColor = R.color.workRosterAppPalette.workShiftDayColor()
            break
        case .morning:
            backgroundColor = R.color.workRosterAppPalette.workShiftMorningColor()
            break
        case .evening:
            backgroundColor = R.color.workRosterAppPalette.workShiftEveningColor()
            break
        case .night:
            backgroundColor = R.color.workRosterAppPalette.workShiftNightColor()
            break
        case .free, .empty:
            backgroundColor = R.color.workRosterAppPalette.workShiftFreeColor()
            break
        }
        
        
        dayColors = DayColors(textColor:R.color.workRosterAppPalette.weekdaySymbolTextColor(), backgroundColor: backgroundColor!)
        
        return dayColors
    }
    
    override public func currentMonthDayColors(forDate date:Date) -> DayColors {
        let workShift = roster.workShift(forDate: date)
        var dayColors = RosterCalendarColors.color(with: workShift)
        
        if roster.isDateCurrentDay(date) {
            dayColors.textColor = R.color.workRosterAppPalette.currentDayTextColor()
        }
        
        return dayColors
    }
    
    override public func otherMonthsDayColors(forDate date: Date) -> DayColors {
        let colors = currentMonthDayColors(forDate: date)
        
        return colors.withAlphaComponent(0.2)
    }
}