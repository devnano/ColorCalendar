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
    lazy var colorCalendar:ColorCalendarView = ColorCalendarView(frame:CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
            let highlight = CalendarHighlights(Date())
            highlight.firstWeekdayOffset = 1
        
            view.addSubview(colorCalendar)
            colorCalendar.calendar = highlight
    
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
