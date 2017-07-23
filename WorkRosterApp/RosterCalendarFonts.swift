//
//  RosterCalendarFonts.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 19/07/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit
import ColorCalendar
import Roster

class RosterCalendarFonts: CalendarFonts {
    var roster:Roster    
    
    public init(roster:Roster) {
        self.roster = roster
        super.init()
    }
    
    override public func fontFor(date: Date) -> UIFont {
        return roster.isDateCurrentDay(date) ? boldFont(size: CalendarFonts.dateFontSize) : super.fontFor(date: date)
    }
    
}
