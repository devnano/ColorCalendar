//
//  ColorCalendarDataSource.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 8/08/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import Foundation

@objc public protocol ColorCalendarViewDataSource: class {
    func colorCalendar(_ calendar: ColorCalendarView, accesibilityLabelForDate date: Date) -> String
    @objc optional func colorCalendar(_ calendar: ColorCalendarView, overlayViewFor date: Date) -> UIView?
}

open class DefaultColorCalendarViewDataSource: ColorCalendarViewDataSource {
    
    public init() {
        
    }
    public func colorCalendar(_ calendar: ColorCalendarView, accesibilityLabelForDate date: Date) -> String {
        return date.full(withLocale: Locale.current)
    }
}
