//
//  Calendar.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 12/26/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import Foundation

public class CalendarDate {
    private var calendar:NSCalendar
    private var date:Date
    
    required public init(_ date:Date) {
        self.calendar = NSCalendar.current as NSCalendar
        self.date = date        
    }
    
    var daysPerWeek:Int {
        get {
            let range = calendar.range(of: .day, in: .weekOfMonth, for: date)
            return range.length
        }
    }
    
    var weeksPerMonth:Int {
        get {
            let range = calendar.range(of: .weekOfMonth, in: .month, for: date)
            return range.length
        }
    }
}
