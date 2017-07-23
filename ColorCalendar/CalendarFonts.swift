//
//  CalendarFonts.calendarFonts.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 29/06/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit



open class CalendarFonts {
    
    public static var calendarFonts = CalendarFonts()
    
    // iPhone 7 screen as reference
    private static let referenceScreenPoints: CGFloat =  736
    public static let dateFontSize: CGFloat =  20
    
    public init() {
    }
    
    public func defaultFont(size: CGFloat) -> UIFont {
        return UIFont(name: UIFont.systemFont(ofSize: 18).fontName, size: adjustSizeByScreenSize(size: size))!
    }
    
    public func boldFont(size: CGFloat) -> UIFont {
        return UIFont(name: UIFont.boldSystemFont(ofSize: 18).fontName, size: adjustSizeByScreenSize(size: size))!
    }
    
    public func boldItalicFont(size: CGFloat) -> UIFont {
        
        return UIFont(name: UIFont.italicSystemFont(ofSize: 18).fontName, size: adjustSizeByScreenSize(size: size))!
    }
    
    public var weekdaysSymbolFont: UIFont {
        return defaultFont(size: CalendarFonts.dateFontSize)
    }
    
    open func fontFor(date: Date) -> UIFont {
        return defaultFont(size: CalendarFonts.dateFontSize)
    }
    
    // TODO: find all usages and refactore to a more generic method (is not being used just for fonts)    
    public func adjustSizeByScreenSize(size: CGFloat) -> CGFloat {
        
        let frame = UIScreen.main.bounds
        let points = max(frame.size.width, frame.size.height)
        let resultingSize = CGFloat(size) * (CGFloat(points) / CalendarFonts.referenceScreenPoints)
        if min(frame.size.width, frame.size.height) / points > 0.7 {
            // XXX: iPad aspect ratio, reduce font size to avoid growing UI too much vertically
            return resultingSize * 0.8
        }
        
        return resultingSize
    }

}
