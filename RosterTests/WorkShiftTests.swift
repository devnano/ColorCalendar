//
//  WorkShiftTests.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 2/26/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import XCTest
@testable import Roster

class WorkShiftTests: XCTestCase {
    
    func testIsWorkDay() {
        XCTAssert(WorkShift.day.isWorkDay)
        XCTAssert(WorkShift.afternoon.isWorkDay)
        XCTAssert(WorkShift.night.isWorkDay)
        XCTAssert(WorkShift.morning.isWorkDay)
        XCTAssert(!WorkShift.free.isWorkDay)
        XCTAssert(!WorkShift.empty.isWorkDay)
    }
    
    func testArrayNextCircular() {
        let array: [WorkShift] = [.day, .night, .afternoon, .morning]
        
        XCTAssert(array.ciruclarNextElement(.day) == .night)
        XCTAssert(array.ciruclarNextElement(.morning) == .day)
    }
    
    func testArrayPreviousCircular() {
        let array: [WorkShift] = [.day, .night, .afternoon, .morning]
        
        XCTAssert(array.ciruclarPreviousElement(.day) == .morning)
        XCTAssert(array.ciruclarPreviousElement(.morning) == .afternoon)
    }
    
    func testRotationDirection() {
        XCTAssert(WorkShift.night.rotationDirection(to: .morning) == 1)
        XCTAssert(WorkShift.morning.rotationDirection(to: .night) == -1)
        XCTAssert(WorkShift.day.rotationDirection(to: .night) == 0)
        XCTAssert(WorkShift.night.rotationDirection(to: .day) == 0)
        XCTAssert(WorkShift.day.rotationDirection(to: .morning) == -1)
        XCTAssert(WorkShift.morning.rotationDirection(to: .afternoon) == 0)
    }
    
    func testFromRawValueWithLocaleAfternoon() {
        let shift = WorkShift.from(rawValue: "T", locale: Locale(identifier: "ES_ar"))
        
        XCTAssert(shift == .afternoon)
    }
    
    func testFromRawValueWithLocaleDay() {
        let shift = WorkShift.from(rawValue: "D", locale: Locale(identifier: "ES_ar"))
        
        XCTAssert(shift == .day)
    }
    
    func testFromRawValueWithLocaleFree() {
        let shift = WorkShift.from(rawValue: "X", locale: Locale(identifier: "ES_ar"))
        
        XCTAssert(shift == .free)
    }
    
    func testLocalizedRawValueWithLocale() {
        XCTAssert(WorkShift.day.localizedRawValue(locale: Locale(identifier: "ES_ar")) == "D")
        XCTAssert(WorkShift.afternoon.localizedRawValue(locale: Locale(identifier: "ES_ar")) == "T")
    }
}
