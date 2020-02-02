//
//  DatePickerCell.swift
//  KUtalog
//
//  Created by HASAN CAN on 2/2/20.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit

protocol DatePickerCellDelegate: AnyObject {
    func didTapDoneDate(date: Date)
    func didDateChanged(date: Date)
}

class DatePickerCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    var savedDate: Date?
    weak var delegate: DatePickerCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.textField.setInputViewDatePicker(target: self,
                                              selector: #selector(tapDone),
                                              dateSelector: #selector(handleDatePicker(_:)))

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
    }

    @objc func tapDone() {
        if let datePicker = self.textField.inputView as? UIDatePicker {
            let date = datePicker.date
            self.savedDate = date
            delegate?.didTapDoneDate(date: date)
        }

        self.textField.resignFirstResponder()
    }

    @objc func handleDatePicker(_ datePicker: UIDatePicker) {
        let date = datePicker.date
        delegate?.didDateChanged(date: date)
        self.textLabel?.text = DateFormatter.short(date)
        self.detailTextLabel?.text = DateFormatter.hour(date)
    }
}
