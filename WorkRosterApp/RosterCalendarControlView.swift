//
//  RosterCalendarControlView.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 1/5/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit
import SnapKit

class RosterCalendarControlView: UIView {
    
    lazy var schemeTextField = UITextField()
    
    lazy var stackView:UIStackView = {
        let view = UIStackView()
        self.addSubview(view)
        
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .leading
        view.spacing = 10
        
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        return view
    }()
    
    var schemeText: String? {
        set {
            schemeTextField.text = newValue
        }
        get {
            return schemeTextField.text
        }
    }
    
    // MARK: - UIView methods
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createUI()
    }

    
    // MARK: - Private API
    
    private func createUI() {
        backgroundColor = .red
        stackView.addArrangedSubview(schemeTextField)
    }
}
