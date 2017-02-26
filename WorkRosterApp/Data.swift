//
//  Data.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 1/5/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import Foundation
import Roster

struct Data {
    // MARK: - Constants
    
    private static let currentShiftRotaKey = "currentShiftRotaKey"
    
    // MARK: - Internal API
    
    static var currentShiftRota:ShiftRota {
        get {
            if let shiftRota = shiftRota(forKey: currentShiftRotaKey) {
                return shiftRota
            }
            
            return allShiftRotas.first!
        }
        set {
            set(newValue, forkey: currentShiftRotaKey)
        }
    }
    
    static var allShiftRotas:[ShiftRota] {
        return [ShiftRota(name:"default", format:"M,D,D,D,X,E,N"), ShiftRota(name:"1 change", format:"D,")]
    }
    
    // MARK: - Private Methods
    
    private static func shiftRota(forKey key:String) -> ShiftRota? {
        return object(forKey: key) as! ShiftRota?
    }
    
    private static func object(forKey key:String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    private static func string(forKey key:String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    private static func set(_ value: Any?, forkey key:String) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
