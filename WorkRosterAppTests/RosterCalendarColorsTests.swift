//
//  WorkRosterAppTests.swift
//  WorkRosterAppTests
//
//  Created by Mariano Heredia on 12/22/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import XCTest
@testable import WorkRosterApp
import ColorCalendar
import Roster

class RosterCalendarColorsTests: XCTestCase {
    var firstWorkDay:Date!
    var highlight:CalendarHighlights!
    var shiftRota:String!
    var roster:Roster!
    var rosterCalendarColors:RosterCalendarColors!
    
    override func setUp() {
        super.setUp()
        var components = DateComponents()
        components.month = 1
        components.day = 8
        components.year = 2017
        components.hour = 8
        firstWorkDay = Calendar.current.date(from: components)
        let shiftRota = ShiftRota(name:"", format:"M,D,D,D,X,E,N")
        highlight = CalendarHighlights(firstWorkDay)
        roster = Roster(shiftRota: shiftRota, firstWorkDay: firstWorkDay)
        rosterCalendarColors = RosterCalendarColors(roster: roster)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRosterCalendarColorsFirstDayOfWork() {
        let resultColors = rosterCalendarColors.currentMonthDayColors(forDate: firstWorkDay)
        XCTAssert(resultColors.backgroundColor == R.color.workRosterAppPalette.workShiftMorningColor())
    }
    
    func testRosterCalendarColorsSecondDayOfWork() {
        // M,D,D,D,X,E,N
        let date = NSCalendar.current.date(byAdding: .day, value: 1, to: firstWorkDay)!
        let resultColors = rosterCalendarColors.currentMonthDayColors(forDate: date)
        XCTAssert(resultColors.backgroundColor == R.color.workRosterAppPalette.workShiftDayColor())
    }
    
    func testRosterCalendarColorsSecondDayOfWorkWhenThereIsLessThan24HoursOfDifference() {
        // M,D,D,D,X,E,N
        var components = DateComponents()
        components.hour = 20
        let date = NSCalendar.current.date(byAdding: components, to: firstWorkDay)!
        
        let resultColors = rosterCalendarColors.currentMonthDayColors(forDate: date)
        XCTAssert(resultColors.backgroundColor == R.color.workRosterAppPalette.workShiftDayColor())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
