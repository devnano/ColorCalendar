//
//  ShiftRotaGenerator.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 2/26/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import Foundation

public struct ShiftRotaGenerator {
    public var shiftworkType: ShiftworkType
    public var shiftSystem: ShiftSystem
    public var shiftsPerDay: [WorkShift]
    
    public init(shiftworkType: ShiftworkType, shiftSystem: ShiftSystem, shiftsPerDay: [WorkShift]) {
        self.shiftworkType = shiftworkType
        self.shiftSystem = shiftSystem
        self.shiftsPerDay = shiftsPerDay
    }
    
    public func generate() -> [ShiftRota] {
        var array = [ShiftRota]()
        
        
        for shift in shiftsPerDay {
            var currentShift = shift
            var shiftSequence = [WorkShift]()
            var currentShiftCount = 0
            
            for _ in 1...shiftSystem.workDays {
                
                if let speed = shiftworkType.rotatingSpeed {
                    if abs(speed) == currentShiftCount {
                        if speed < 0 {
                            currentShift = shiftsPerDay.ciruclarPreviousElement(currentShift)!
                        } else {
                            currentShift = shiftsPerDay.ciruclarNextElement(currentShift)!
                        }
                        currentShiftCount = 0
                    }
                }
                
                shiftSequence.append(currentShift)
                currentShiftCount += 1
            }
            
            for _ in 1...shiftSystem.freeDays {
                shiftSequence.append(.free)
            }
            
            let name = "\(shiftSystem) \(ShiftRota.localizedFormat(from: shiftSequence))"
            
            let rota = ShiftRota(name: name, workSequence: shiftSequence)
            array.append(rota)
        }
        
        return array
    }
}
