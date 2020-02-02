//
//  TitleCell.swift
//  KUtalog
//
//  Created by HASAN CAN on 2/2/20.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit

protocol TitleCellDelegate: AnyObject {
    func titleDidChange(title: String?)
}

class TitleCell: UITableViewCell {
    @IBOutlet weak var titleTextField: UITextField!
    weak var delegate: TitleCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextField?.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func didChangeValue(_ sender: Any) {
        self.delegate?.titleDidChange(title: titleTextField.text)
    }
}
