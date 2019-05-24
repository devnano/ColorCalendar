//
//  Date.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 8/08/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import Foundation

extension Date {
    public var yyyymmdd: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return formatter.string(from: self)
    }
    
    public func monthName(withLocale locale: Locale) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.locale = locale
        
        return formatter.string(from: self).capitalized
    }
    
    public func year(withCalendar calendar: Calendar) -> Int {
        let year = calendar.component(.year, from: self)
        
        return year
    }
    
//    public func dayOrdinal(withCalendar calendar: Calendar) -> String {
//        let formatter = NumberFormatter()
//        let day = calendar.component(.day, from: self)
//        formatter.numberStyle = .ordinal        
//        
//        return formatter.string(from: day as NSNumber)!
//    }
//    
    public func full(withLocale locale: Locale) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.locale = locale
        
        return dateFormatter.string(from: self).capitalized
    }
    
    
    public func short(withLocale locale: Locale) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.locale = locale
        
        return dateFormatter.string(from: self).capitalized
    }
}
