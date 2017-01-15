//
//  Roster.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 1/4/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import Foundation

public class Roster {
    var workShiftSequence:[WorkShift]
    var firstWorkDay:Date
    
    public init?(workShiftFormat:String, firstWorkDay:Date) {
        let components = workShiftFormat.components(separatedBy: ",")
        workShiftSequence = []
        
        for component in components {
            let trimComponent = component.trimmingCharacters(in: .whitespaces)
            guard let workShift = WorkShift(rawValue:trimComponent) else {
                return nil
            }
            workShiftSequence.append(workShift)
        }
        
        // day is finest grain info we need:
        let calendar = NSCalendar.current
        let dateComponents = calendar.dateComponents([.day, .month, .year], from:firstWorkDay)        
        
        self.firstWorkDay = calendar.date(from: dateComponents)!
    }
    
    public func workShift(forDate date:Date) -> WorkShift {
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.day], from: firstWorkDay, to: date)
        var daysOffset = dateComponents.day! % workShiftSequence.count
        
        if daysOffset < 0 {
            daysOffset = workShiftSequence.count + daysOffset
        }       
        
        return workShiftSequence[daysOffset]
    }
    
    public func isDateCurrentDay(_ date:Date) -> Bool {
        let areSameDayMonthYear:(Date, Date) -> (Bool) = {(firstDate, secondDate) in
            let components = Set([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year])
            let calendar = NSCalendar.current
            var firstDateComponents = calendar.dateComponents(components, from: firstDate)
            var secondDateComponents = calendar.dateComponents(components, from: secondDate)
            firstDateComponents.calendar = calendar
            secondDateComponents.calendar = calendar
    
            return firstDateComponents.date! .compare(secondDateComponents.date!) == .orderedSame
        }
        
        return areSameDayMonthYear(date, Date())
    }
}
