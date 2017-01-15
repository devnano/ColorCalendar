//
//  ViewController.swift
//  WorkRosterApp
//
//  Created by Mariano Heredia on 12/22/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import ColorCalendar
import SnapKit
import Roster

class ViewController: UIViewController {
    // MARK: - Properties
    
    lazy var colorCalendar = ColorCalendarView(frame:CGRect())
    lazy var controlView: RosterCalendarControlView = {
        let view = RosterCalendarControlView(frame:CGRect())
        view.delegate = self
        
        return view
    }()
    
    lazy var firstWorkDay:Date = {
        let date = Date()
        
        return date
    }()
    
    lazy var calendarHighlight:CalendarHighlights = {
        
        let highlight = CalendarHighlights(self.firstWorkDay)
        
        return highlight
    }()
    
    lazy var workScheme = Data.currentWorkScheme
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let roster = Roster(workScheme: workScheme, firstWorkDay: firstWorkDay)!
        
        calendarHighlight.firstWeekdayDay = 2
        
        set(roster:roster)
    
        view.addSubview(colorCalendar)
        view.addSubview(controlView)
        
        colorCalendar.calendar = calendarHighlight
        makeCalendarConstraints(traitsCollection: self.traitCollection)
        makeControlViewConstraints(traitsCollection: self.traitCollection)        
        
        controlView.firstWorkDayDate = firstWorkDay
        controlView.workScheme = workScheme
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection!) {
        makeCalendarConstraints(traitsCollection: self.traitCollection)
        makeControlViewConstraints(traitsCollection: self.traitCollection)
    }
    
    // MARK: - Private Methods
    
    typealias ConstraintMaker = (SnapKit.ConstraintMaker) -> Void
    
    private func makeTraitsDependantConstraints(traitsCollection: UITraitCollection, compactMaker: @escaping ConstraintMaker, regularMaker: @escaping ConstraintMaker) -> ConstraintMaker {
        if traitsCollection.verticalSizeClass == .regular {
            return compactMaker
        } else {
            return regularMaker
        }
    }
    
    private func makeCalendarConstraints(traitsCollection: UITraitCollection) {
        func makeCalendarHorizontalCompactConstraints(_ make:SnapKit.ConstraintMaker) {
            make.centerX.equalToSuperview()
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
        }
        
        func makeCalendarVerticalCompactConstraints(_ make:SnapKit.ConstraintMaker) {
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        colorCalendar.snp.remakeConstraints {(make) -> Void in
            let mediumPriority = 750
            
            // Required:
            makeTraitsDependantConstraints(traitsCollection: traitCollection,
                                           compactMaker: makeCalendarHorizontalCompactConstraints,
                                           regularMaker: makeCalendarVerticalCompactConstraints)(make)

            make.width.equalTo(colorCalendar.snp.height)
            make.width.height.lessThanOrEqualToSuperview()
            
            // Nice to have:
            make.left.right.equalToSuperview().priority(mediumPriority)
            make.bottom.equalToSuperview().priority(mediumPriority)
        }
    }
    
    private func makeControlViewConstraints(traitsCollection: UITraitCollection) {
        func makeCalendarHorizontalCompactConstraints(_ make:SnapKit.ConstraintMaker) {
            make.top.equalTo(colorCalendar.snp.bottom)
            make.left.equalToSuperview()
        }
        
        func makeCalendarVerticalCompactConstraints(_ make:SnapKit.ConstraintMaker) {
            make.top.equalToSuperview()
            make.left.equalTo(colorCalendar.snp.right)
        }
        
        controlView.snp.remakeConstraints {(make) -> Void in
            makeTraitsDependantConstraints(traitsCollection: traitCollection,
                                           compactMaker: makeCalendarHorizontalCompactConstraints,
                                           regularMaker: makeCalendarVerticalCompactConstraints)(make)
            make.bottom.right.equalToSuperview()
        }
    }
    
    fileprivate func set(roster: Roster, reloadCalendar reload:Bool=false) {
        setCalendarColors(RosterCalendarColors(roster:roster))
        if reload {
            colorCalendar.reloadCalendar()
        }
    }
}

extension ViewController: RosterCalendarControlViewDelegate {
    internal func controlView(_ controlView: RosterCalendarControlView, didChangeWorkScheme workScheme: WorkScheme) {
        self.workScheme = workScheme
        guard let roster = Roster(workScheme: workScheme, firstWorkDay: firstWorkDay) else {
            // TODO: errors
            return
        }
        
        set(roster:roster, reloadCalendar: true)
    }

    internal func controlView(_ controlView: RosterCalendarControlView, didChangeFirstWorkDay firstWorkDay: Date?) {
        guard let firstWorkDay = firstWorkDay else {
            // TODO: error messages
            return
        }        
        
        guard let roster = Roster(workScheme: workScheme, firstWorkDay: firstWorkDay) else {
            // TODO: error messages
            return
        }
        
        set(roster:roster, reloadCalendar: true)
    }
}
