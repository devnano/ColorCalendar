//
//  ColorCalendarDataSource.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 8/08/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import Foundation

public protocol ColorCalendarViewDataSource {
    func colorCalendar(_ calendar: ColorCalendarView, accesibilityLabelForDate date: Date) -> String    
}

internal class DefaultColorCalendarViewDataSource: ColorCalendarViewDataSource {
    func colorCalendar(_ calendar: ColorCalendarView, accesibilityLabelForDate date: Date) -> String {
        return "August the 8th, 2017"
    }
}
