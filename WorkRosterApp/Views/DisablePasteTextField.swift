//
//  DisableActionsTextField.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 26/07/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit

class DisableActionsTextField: UITextField {
    
    var disableAllActions: Bool = false
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return !disableAllActions
//        if !disableAllActions {
//            return true
//        }
//        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
//            return false
//        }
//        
//        return true
    }

}
