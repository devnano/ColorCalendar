//
//  ShiftRotaGenerator.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 2/26/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import XCTest
@testable import Roster

class ShiftRotaGeneratorTests: XCTestCase {
    
    var system: ShiftSystem!
    var shiftworkType: ShiftworkType!
    var rotatingDirection: RotatingDirection!
    var generator: ShiftRotaGenerator!    
    
    override func setUp() {
        super.setUp()
        system = ShiftSystem(workDays: 3, freeDays: 1)
        shiftworkType = .rotating(.clockwise(1))
        createGenerator()
    }
    
    func createGenerator() {
        generator = ShiftRotaGenerator(shiftworkType: shiftworkType, shiftSystem: system, shiftsPerDay: WorkShift.threeShiftsPerDay)
    }
    
    func testGenerateClockwise1DayRotating3by1System3ShiftsPerDay() {
        let rotas = generator.generate()
        
        XCTAssert(rotas.count > 0)
        
        for rota in rotas {
            XCTAssert(rota.shiftSystem!.freeDays == 1)
            XCTAssert(rota.shiftSystem!.workDays == 3)
            var previousShift: WorkShift?
            
            for shift in rota.workShiftSequence! {
                XCTAssert(WorkShift.threeShiftsPerDay.contains(shift) || WorkShift.freeShifts.contains(shift))
                
                if WorkShift.threeShiftsPerDay.contains(shift) {
                    if previousShift != nil {
                        let nextShift = WorkShift.threeShiftsPerDay.ciruclarNextElement(previousShift!)! as WorkShift
                        XCTAssert(shift == nextShift)
                    }
                    previousShift = shift
                }
            }
        }
    }
    
    func testGenerateFixed3by1System3ShiftsPerDay() {
        shiftworkType = .fixed
        createGenerator()
        let rotas = generator.generate()
        
        XCTAssert(rotas.count > 0)
        
        for rota in rotas {
            XCTAssert(rota.shiftSystem!.freeDays == 1)
            XCTAssert(rota.shiftSystem!.workDays == 3)
            var previousShift: WorkShift?
            
            for shift in rota.workShiftSequence! {
                XCTAssert(WorkShift.threeShiftsPerDay.contains(shift) || WorkShift.freeShifts.contains(shift))
                
                if WorkShift.threeShiftsPerDay.contains(shift) {
                    if previousShift != nil {
                        XCTAssert(shift == previousShift)
                    }
                    previousShift = shift
                }
            }
        }
    }
}
