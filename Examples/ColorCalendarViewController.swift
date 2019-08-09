//
//  ColorCalendarViewController.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 8/08/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit
import ColorCalendar


class ColorCalendarViewController: UIViewController {
    @IBOutlet weak var colorCalendarView: ColorCalendarView!
    @IBOutlet fileprivate weak var outputLabel: UILabel!
    private var delegate: ColorCalendarViewDelegate!
    var lastTappedDate: Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = createColorCalendarViewDelegate()
        colorCalendarView.delegate = delegate
        colorCalendarView.dataSource = Lazy({return TestColorCalendarViewDataSource(self)})
    }
    @IBAction func onAddRandomTextTap(_ sender: Any) {
        outputLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla pretium imperdiet neque sed pretium. Etiam id elit porttitor, dapibus magna a, eleifend felis. Interdum et malesuada fames ac ante ipsum primis in faucibus. Duis ornare sollicitudin lacus in pretium. Ut pellentesque orci ac elit mollis efficitur."
    }
}

extension ColorCalendarViewController {
    func createColorCalendarViewDelegate() -> ColorCalendarViewDelegate {
        return TestColorCalendarViewDelegate(self)
    }
}

class TestColorCalendarViewDataSource: DefaultColorCalendarViewDataSource {
    unowned let colorCalendarViewController: ColorCalendarViewController
    
    required init(_ colorCalendarViewController: ColorCalendarViewController) {
        self.colorCalendarViewController = colorCalendarViewController
    }
    
    func colorCalendar(_ calendar: ColorCalendarView, overlayViewFor date: Date) -> UIView? {
        if colorCalendarViewController.lastTappedDate == date {
            let overlay = UILabel()
            let text = "\(self.colorCalendar(calendar, accesibilityLabelForDate: date)) Overlay View"
            overlay.text = text
            overlay.accessibilityLabel = text
            overlay.adjustsFontSizeToFitWidth = true
            overlay.textColor = .green
            
            return overlay
        }
        
        return nil
    }
}

class TestColorCalendarViewDelegate: ColorCalendarViewDelegate {
    unowned let colorCalendarViewController: ColorCalendarViewController
    
    required init(_ colorCalendarViewController: ColorCalendarViewController) {
        self.colorCalendarViewController = colorCalendarViewController
    }
    
    func colorCalendarDidSwipeCalendarForward(_ calendar: ColorCalendarView) {
    }
    func colorCalendarDidSwipeCalendarBackward(_ calendar: ColorCalendarView) {
    }
    
    func colorCalendarDidMoveCalendarForward(_ calendar: ColorCalendarView) {
    }
    func colorCalendarDidMoveCalendarBackward(_ calendar: ColorCalendarView) {
    }
    func colorCalendarDidTapMonthName(_ calendar: ColorCalendarView) {
    }
    func colorCalendar(_ calendar: ColorCalendarView, didTapWeekdaySymbolAtIndex index: Int) {
    }
    func colorCalendar(_ calendar: ColorCalendarView, didTapCalendarDay date: Date, isWithinCurrentCalendarPeriod: Bool, in window: UIWindow, from frame: CGRect) {
        let text = date.full(withLocale: Locale.current)
        colorCalendarViewController.outputLabel.text = text
        colorCalendarViewController.outputLabel.accessibilityLabel = text
        colorCalendarViewController.lastTappedDate = date
        calendar.reloadCalendar()
    }
}




