//
//  DatePickerCell.swift
//  KUtalog
//
//  Created by HASAN CAN on 2/2/20.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit

protocol DatePickerCellDelegate {
    func didTapDoneDate(_ date: Date)
}

class DatePickerCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    var savedDate: Date?
    var delegate: DatePickerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let date = savedDate {
            self.textLabel?.text = DateFormatter.short(date)
            self.detailTextLabel?.text = DateFormatter.hour(date)
        } else {
            self.textLabel?.text = DateFormatter.short(Date())
            self.detailTextLabel?.text = DateFormatter.hour(Date())
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        textField.becomeFirstResponder()
    }
    
    func setInputViewDatePicker(target: Any) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        textField.inputView = datePicker
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(tapDone))
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        textField.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        if let date = savedDate {
            self.textLabel?.text = DateFormatter.short(date)
            self.detailTextLabel?.text = DateFormatter.hour(date)
        } else {
            self.textLabel?.text = DateFormatter.short(Date())
            self.detailTextLabel?.text = DateFormatter.hour(Date())
        }
        self.resignFirstResponder()
    }
    
    @objc func tapDone() {
        if let datePicker = self.textField.inputView as? UIDatePicker {
            let date = datePicker.date
            self.savedDate = date
            delegate?.didTapDoneDate(date)
        }
        self.textField.resignFirstResponder()
    }
    
    @objc private func handleDatePicker(_ datePicker: UIDatePicker) {
        let date = datePicker.date
        self.textLabel?.text = DateFormatter.short(date)
        self.detailTextLabel?.text = DateFormatter.hour(date)
    }
}
