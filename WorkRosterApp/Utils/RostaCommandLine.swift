//
//  RostaCommandLine.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 27/07/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit

class RostaCommandLine {
    
    class var defaultWorkScheme: String? {
        return UserDefaults.standard.string(forKey: "defaultWorkScheme") ?? (CommandLine.argc < 2 ? nil : CommandLine.arguments[1])
    }
    
    class var generateIcons: Bool {
        return CommandLine.argc > 2 && NSString(string: CommandLine.arguments[2]).boolValue
    }
    
    class var generateLaunchScreen: Bool {
        guard let generateLaunchScreen = UserDefaults.standard.string(forKey: "generateLaunchScreen") else {
            return CommandLine.argc > 3 && NSString(string: CommandLine.arguments[3]).boolValue
        }
        
        return NSString(string: generateLaunchScreen).boolValue
    }
}
