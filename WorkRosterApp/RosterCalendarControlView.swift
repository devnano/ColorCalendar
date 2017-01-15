//
//  RosterCalendarControlView.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 1/5/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit
import SnapKit
import Roster

// TODO: controls colors
class RosterCalendarControlView: UIView {
    
    // MARK: Properties
    
    var workScheme: WorkScheme {
        didSet {
            schemeName = workScheme.name
            schemeText = workScheme.format
        }
    }
    
    lazy var schemeNameTextField: UITextField = {
        let textField = UITextField()
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        textField.inputView = pickerView
        
        return textField
    }()
    
    lazy var schemeTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.keyboardType = .asciiCapable
        textField.addTarget(self, action: #selector(schemeTextChanged), for: .editingChanged)
        
        return textField
    }()
    
    lazy var firstWorkDayTextField:UITextField = {
        let textField = UITextField()
        textField.delegate = self
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hideDatePicker))
        let datePickerView = UIDatePicker()
        
        toolbar.snp.makeConstraints { (make) in
            make.height.equalTo(30)
        }
        
        toolbar.setItems([doneButton], animated: false)
        datePickerView.datePickerMode = .date
        textField.inputView = datePickerView
        textField.inputAccessoryView = toolbar
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        return textField
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        self.addSubview(view)
        
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .leading
        view.spacing = 10
        
        view.snp.makeConstraints({ (make) in
            make.left.top.right.equalToSuperview()
        })
        
        return view
    }()
    
    private var schemeText: String {
        set {
            schemeTextField.text = newValue
        }
        get {
            return schemeTextField.text ?? ""
        }
    }
    
    private var schemeName: String {
        set {
            let name = workSchemeNameOrDefault(newValue)
            schemeNameTextField.text = name
        }
        get {
            return schemeNameTextField.text ?? ""
        }
    }
    
    var firstWorkDayDate: Date? {
        didSet {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            
            firstWorkDayTextField.text = dateFormatter.string(from: firstWorkDayDate!)
        }
    }
    
    var delegate: RosterCalendarControlViewDelegate?
    
    // MARK: - UIView methods
    
    public override init(frame: CGRect) {
        workScheme = Data.currentWorkScheme
        super.init(frame: frame)
        createUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        workScheme = Data.currentWorkScheme
        super.init(coder: aDecoder)
        createUI()
    }
    
    
    // MARK: - Private API
    
    private func createUI() {
        stackView.addArrangedSubview(schemeNameTextField)
        stackView.addArrangedSubview(schemeTextField)
        stackView.addArrangedSubview(firstWorkDayTextField)        
    }
    
    fileprivate func workSchemeNameOrDefault(_ workSchemeName:String) -> String {
        return workSchemeName != "" ? workSchemeName : R.string.localizable.controlViewButtonWorkSchemeTitle()
    }
    
    @objc private func hideDatePicker() {
        firstWorkDayTextField.resignFirstResponder()
    }
    
    @objc private func showWorkSchemePicker() {
        
    }
    
    @objc private func datePickerValueChanged(sender:UIDatePicker) {
        firstWorkDayDate = sender.date
        delegate?.controlView(self, didChangeFirstWorkDay: firstWorkDayDate)
    }
}

extension RosterCalendarControlView: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    
    @objc fileprivate func schemeTextChanged() {
        workScheme = WorkScheme(name: "", format: workScheme.format)
        delegate?.controlView(self, didChangeWorkScheme: workScheme)
    }
}

extension RosterCalendarControlView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Data.allWorkSchemes.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return workSchemeNameOrDefault(Data.allWorkSchemes[row].name)
    }
}

protocol RosterCalendarControlViewDelegate {
    func controlView(_ controlView: RosterCalendarControlView, didChangeWorkScheme workScheme: WorkScheme)
    func controlView(_ controlView: RosterCalendarControlView, didChangeFirstWorkDay firstWorkDay: Date?)
}
