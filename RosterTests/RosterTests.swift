//
//  RosterTests.swift
//  RosterTests
//
//  Created by Mariano Heredia on 1/4/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import XCTest
@testable import Roster

class RosterTests: XCTestCase {
    
    var roster:Roster!
    var firstWorkDay:Date!
    
    override func setUp() {
        super.setUp()
        var components = DateComponents()
        components.month = 1
        components.day = 4
        components.year = 2017
        components.hour = 8
        firstWorkDay = Calendar.current.date(from: components)
        
        roster = Roster(shiftRota: ShiftRota("M,D,D,D,X,A,N"), firstWorkDay: firstWorkDay)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testInitialization() {
        roster = Roster(shiftRota: ShiftRota("M,M,D,X"), firstWorkDay: firstWorkDay)!
        
        XCTAssert(roster.workShiftSequence.count == 4)
        XCTAssert(roster.workShiftSequence[0] == .morning)
        XCTAssert(roster.workShiftSequence[1] == .morning)
        XCTAssert(roster.workShiftSequence[2] == .day)
        XCTAssert(roster.workShiftSequence[3] == .free)
    }
    
    func testLowercaseInitialization() {
        roster = Roster(shiftRota: ShiftRota("m,m,d,x"), firstWorkDay: firstWorkDay)!
        
        XCTAssert(roster.workShiftSequence.count == 4)
        XCTAssert(roster.workShiftSequence[0] == .morning)
        XCTAssert(roster.workShiftSequence[1] == .morning)
        XCTAssert(roster.workShiftSequence[2] == .day)
        XCTAssert(roster.workShiftSequence[3] == .free)
    }
    
    func testInitializationWithEmptyComponent() {
        roster = Roster(shiftRota: ShiftRota("M,M,D,X,,"), firstWorkDay: firstWorkDay)!
        
        XCTAssert(roster.workShiftSequence.count == 6)
        XCTAssert(roster.workShiftSequence[0] == .morning)
        XCTAssert(roster.workShiftSequence[1] == .morning)
        XCTAssert(roster.workShiftSequence[2] == .day)
        XCTAssert(roster.workShiftSequence[3] == .free)
        XCTAssert(roster.workShiftSequence[4] == .free)
        XCTAssert(roster.workShiftSequence[5] == .free)
    }
    
    
    func testInitializationWithValidBlankSpaces() {
        roster = Roster(shiftRota: ShiftRota("M ,M ,D ,X "), firstWorkDay: firstWorkDay)!
        
        XCTAssert(roster.workShiftSequence.count == 4)
        XCTAssert(roster.workShiftSequence[0] == .morning)
        XCTAssert(roster.workShiftSequence[1] == .morning)
        XCTAssert(roster.workShiftSequence[2] == .day)
        XCTAssert(roster.workShiftSequence[3] == .free)
    }
    
    func testInitializationBadFormat() {
        roster = Roster(shiftRota: ShiftRota("esta"), firstWorkDay: firstWorkDay)
        
        XCTAssert(roster == nil)
    }
    
    func testInitializationBadFormat2() {
        roster = Roster(shiftRota: ShiftRota("esta,esta,esta,,esta"), firstWorkDay: firstWorkDay)
        
        XCTAssert(roster == nil)
    }
    
    func testInitializationBadFormat3() {
        roster = Roster(shiftRota: ShiftRota("M,,esta,,D,"), firstWorkDay: firstWorkDay)
        
        XCTAssert(roster == nil)
    }
    
    func testWorkShiftForFirstWorkDay() {
        let workShift = roster.workShift(forDate:roster.firstWorkDay)
        
        XCTAssert(workShift == .morning)
    }
    
    func testWorkShiftForSecondWorkDay() {
        // M,D,D,D,X,A,N
        let date = NSCalendar.current.date(byAdding: .day, value: 2, to: roster.firstWorkDay)!
        let workShift = roster.workShift(forDate:date)
        
        XCTAssert(workShift == .day)
    }
    
    func testWorkShiftForSecondWorkDayWhenThereIsLessThan24HoursOfDifference() {
        // M,D,D,D,X,A,N
        var components = DateComponents()
        components.hour = 20
        let date = NSCalendar.current.date(byAdding: components, to: firstWorkDay)!        
        let workShift = roster.workShift(forDate:date)
        
        XCTAssert(workShift == .day)
    }
    
    func testWorkShiftForLastWorkDay() {
        // M,D,D,D,X,A,N
        let date = NSCalendar.current.date(byAdding: .day, value: 6, to: roster.firstWorkDay)!
        
        let workShift = roster.workShift(forDate:date)
        
        XCTAssert(workShift == .night)
    }
    
    func testWorkShiftLastDayNextWeek() {
        // M,D,D,D,X,A,N
        let date = NSCalendar.current.date(byAdding: .day, value: 13, to: roster.firstWorkDay)!
        
        let workShift = roster.workShift(forDate:date)
        
        XCTAssert(workShift == .night)
    }
    
    func testWorkShiftPreviousDayToStartignWorkDay() {
        // M,D,D,D,X,A,N
        let date = NSCalendar.current.date(byAdding: .day, value: -1, to: roster.firstWorkDay)!
        
        let workShift = roster.workShift(forDate:date)
        
        XCTAssert(workShift == .night)
    }
    
    func testWorkShiftTwoWeeksBefore() {
        // M,D,D,D,X,A,N
        let date = NSCalendar.current.date(byAdding: .day, value: -9, to: roster.firstWorkDay)!
        
        let workShift = roster.workShift(forDate:date)
        
        XCTAssert(workShift == .afternoon)
    }
    
    func testisDateCurrentDay() {
        XCTAssert(roster.isDateCurrentDay(Date()))
    }
    
    func testDateIsNotCurrentDay() {
        XCTAssert(!roster.isDateCurrentDay(firstWorkDay))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
