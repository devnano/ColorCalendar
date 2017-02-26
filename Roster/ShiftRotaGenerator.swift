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
    var shiftSystemMultiplier: Int
    var shiftsPerDay: Int
}
