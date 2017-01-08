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
    lazy var controlView = RosterCalendarControlView(frame:CGRect())
    var roster:Roster!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstWorkDay = Date()
        let highlight = CalendarHighlights(firstWorkDay)
        let workScheme = Data.currentWorkScheme
        
        roster = Roster(workShiftFormat: workScheme.format, firstWorkDay: firstWorkDay)
        highlight.firstWeekdayDay = 2
        setCalendarColors(RosterCalendarColors(roster:roster))
    
        view.addSubview(colorCalendar)
        view.addSubview(controlView)
        
        colorCalendar.calendar = highlight
        makeCalendarConstraints(traitsCollection: self.traitCollection)
        makeControlViewConstraints(traitsCollection: self.traitCollection)
        
        controlView.schemeText = workScheme.format
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
}
