//
//  ShiftRotaTests.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 1/10/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import XCTest
@testable import Roster

class ShiftRotaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        let format = "D,N,X"
        let scheme = ShiftRota(name: "", format: format)
        
        XCTAssert(scheme.format == format)
    }
    
    func testInitLocale() {
        let format = "D,N,T,X"
        let locale = Locale(identifier: "ES_ar")
        let scheme = ShiftRota(name: "", format: format, locale: locale)
        
        XCTAssert(scheme.format == "D,N,A,X")
        XCTAssert(scheme.localizedFormat(locale: locale) == "D,N,T,X")
    }
    
    func testInitFailLocale() {
        let format = "D,N,T,X,z"
        let locale = Locale(identifier: "ES_ar")
        let scheme = ShiftRota(name: "", format: format, locale: locale)
        
        XCTAssert(scheme.format == "D,N,A,X,Z")
        XCTAssert(scheme.localizedFormat(locale: locale) == "D,N,T,X,Z")
    }
    
    func testLowercaseInit() {
        let format = "d,n,x"
        let scheme = ShiftRota(name: "", format: format)
        
        XCTAssert(scheme.format == format.uppercased())
    }
    
    func testSequenceInit() {
        let sequence: [WorkShift] = [.day, .day, .day, .free, .empty]
        let scheme = ShiftRota(sequence)
        
        XCTAssert(scheme.workShiftSequence! == sequence)
        XCTAssert("D,D,D,X," == scheme.format)
    }
    
    func testGetWorkSchemaShiftSystem() {
        let format = "D,D,D,D,D,,"
        let scheme = ShiftRota(name: "", format: format)
        
        XCTAssert(scheme.shiftSystem!.workDays == 5)
        XCTAssert(scheme.shiftSystem!.freeDays == 2)
    }
    
    func testShiftSystemMultiplier() {
        let system = ShiftSystem(workDays: 3, freeDays: 1)
        let systemBy2 = system * 2
        
        XCTAssert(systemBy2.workDays == 6)
        XCTAssert(systemBy2.freeDays == 2)
    }
    
    func testShiftworkTypeFixed() {
        let format = "D,D,D,D,D,,"
        let scheme = ShiftRota(format)
        
        XCTAssert(scheme.shiftworkType! == .fixed)
    }
    
    func testShiftworkType1DayRotatingClockwise() {
        let format = "D,A,N,M,D,,"
        let scheme = ShiftRota(format)
        
        XCTAssert(scheme.shiftworkType! == .rotating(1))
    }
    
    func testShiftworkType1DayRotatingCounterclockwise() {
        let format = "D,M,N,A,D,,"
        let scheme = ShiftRota(format)
        
        XCTAssert(scheme.shiftworkType! == .rotating(-1))
    }
    
    func testShiftworkType1DayRotatingCounterclockwise2() {
        let format = "M,N,D,"
        let scheme = ShiftRota(format)
        
        XCTAssert(scheme.shiftworkType! == .rotating(-1))
    }
    
    func testShiftworkType1DayRotatingCounterclockwise3() {
        let format = "N,D,M,"
        let scheme = ShiftRota(format)
        
        XCTAssert(scheme.shiftworkType! == .rotating(-1))
    }
    
    func testShiftworkType2DaysRotatingClockwise() {
        let format = "D,D,A,A,N,N,M,M,,"
        let scheme = ShiftRota(format)
        
        XCTAssert(scheme.shiftworkType! == .rotating(2))
    }
    
    func testShiftworkType3DaysRotatingCounterclockwise() {
        let format = "M,M,M,N,N,N,A,A,A,D,D,D,,,,"
        let scheme = ShiftRota(format)
        
        XCTAssert(scheme.shiftworkType! == .rotating(-3))
    }
    
    func testShiftworkTypeIrregular() {
        let format = "D,D,A,A,A,N,N,M,M,,"
        let scheme = ShiftRota(format)
        
        XCTAssert(scheme.shiftworkType! == .irregular)
    }
}
