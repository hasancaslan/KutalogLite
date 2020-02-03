//
//  InfoCell.swift
//  KUtalog
//
//  Created by HASAN CAN on 2/2/20.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit

protocol InfoCellDelegate: AnyObject {
    func infoDidChange(_ infoText: String?)
    func infoDidBeginEditing()
    func infoDidEndEditing()
}

class InfoCell: UITableViewCell {
    @IBOutlet weak var infoTextField: UITextView!
    weak var delegate: InfoCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        infoTextField.delegate = self
        infoTextField.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension InfoCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.infoDidChange(textView.text)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.delegate?.infoDidBeginEditing()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.infoDidEndEditing()
    }
}
