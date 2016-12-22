//
//  ViewController.swift
//  WorkRosterApp
//
//  Created by Mariano Heredia on 12/22/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import ColorCalendar
import SnapKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
            let colorCalendar = ColorCalendarView(frame:CGRect())
            view.addSubview(colorCalendar)
    
            colorCalendar.snp.makeConstraints {(make) -> Void in
                make.left.right.bottom.equalTo(colorCalendar.superview!)
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

