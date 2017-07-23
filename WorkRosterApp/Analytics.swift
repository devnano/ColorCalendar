//
//  Analytics.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 21/07/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit
import Fabric
import Answers
import Crashlytics


class Analytics: NSObject {
    class func setup() {
        Fabric.with([Crashlytics.self, Answers.self])
    }
    
    class func tapOnSwitchForwardOnMonth() {
        logCustomEvent(withName: #function)
    }
    
    class func tapOnSwitchBackwardOnMonth() {
        logCustomEvent(withName: #function)
    }
    
    class func tapOnMonthName() {
        logCustomEvent(withName: #function)
    }
    
    class func tapInWeekdaySymbolAtIndex(_ index: Int) {
        logCustomEvent(withName: #function, customAttributes: ["index": index])
    }
    
    class func tapInCalendarDay(_ date: Date, isCurrentMonth: Bool) {
        logCustomEvent(withName: #function, customAttributes: ["date": date, "isCurrentMonth": isCurrentMonth])
    }
    
    class func tapInfoButton(index: Int, show: Bool) {
        logCustomEvent(withName: #function, customAttributes: ["index": index, "show": show])
    }
    
    class func startEditingTextField(index: Int) {
        logCustomEvent(withName: #function, customAttributes: ["index": index])
    }
    
    class func changeToInvalidShiftRota(format: String) {
        logCustomEvent(withName: #function, customAttributes: ["format": format])
    }
    
    class func changeToValidShiftRota(format: String) {
        logCustomEvent(withName: #function, customAttributes: ["format": format])        
    }
    
    class func changeFirstWorkDay(date: Date) {
        logCustomEvent(withName: #function, customAttributes: ["date": date])
    }
    
    private class func logCustomEvent(withName eventName: String, customAttributes: [String: Any]? = nil) {
        Answers.logCustomEvent(withName: eventName, customAttributes: customAttributes)
    }
}
