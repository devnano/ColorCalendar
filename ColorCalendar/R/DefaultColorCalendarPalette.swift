//
//  DefaultColorCalendarPalette.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 20/09/18.
//  Copyright © 2018 Kartjuba. All rights reserved.
//

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1) {
        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1  // skip #
        
        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)
        
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
            blue:  CGFloat((rgb &     0xFF)      )/255.0,
            alpha: alpha)
    }
}

// Workaround: r.swift only supports colors from iOS 11 on – Assets Catalog Colors
struct DefaultColorCalendarPalette {
    static let backgroundColor = UIColor(hex:"#FFFFFF")
    static let currentMonthDayBackgroundColor = UIColor(hex:"#FFFFFF")
    static let currentMonthDayTextColor = UIColor(hex:"#000000")
    static let defaultTextColor = UIColor(hex:"#000000")
    static let monthSwitcherBackgroundColor = UIColor(hex:"#FFFFFF")
    static let otherMonthsDayBackgroundColor = UIColor(hex:"#FFFFFF")
    static let otherMonthsDayTextColor = UIColor(hex:"#8A8A8A")
    static let weekdaySymbolBackgroundColor = UIColor(hex:"#8A8A8A")
    static let weekdaySymbolTextColor = UIColor(hex:"#000000")
}
