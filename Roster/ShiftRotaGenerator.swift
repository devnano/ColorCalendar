//
//  ShiftRotaGenerator.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 2/26/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import Foundation

typealias RotationSpeed = Int

enum RotatingDirection {
    case clockwise(RotationSpeed)
    case counterclockwise(RotationSpeed)
}

enum ShiftworkType {
    case fixed
    case rotating(RotatingDirection)
}

struct ShiftRotaGenerator {
    var shiftworkType: ShiftworkType
    var shiftSystem: ShiftSystem
    var shiftsPerDay: [WorkShift]
    
    func generate() -> [ShiftRota] {
        var array = [ShiftRota]()
        
        for shift in shiftsPerDay {
            var shiftSequence = [WorkShift]()
            // var previousShift: WorkShift?
            
            for _ in 1...shiftSystem.workDays {
                shiftSequence.append(shift)
            }
            
            for _ in 1...shiftSystem.freeDays {
                shiftSequence.append(.free)
            }
            
            // TODO: create names
            let rota = ShiftRota(shiftSequence)
            array.append(rota)
        }
        
        return array
    }
}
