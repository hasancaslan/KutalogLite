//
//  CetegoryCell.swift
//  KUtalog
//
//  Created by HASAN CAN on 2/2/20.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit

protocol CategoryCellDelegate {
    func categoryDidChange(category: String?)
}

class CategoryCell: UITableViewCell {
    @IBOutlet weak var categoryTextField: UITextField!
    var delegate: CategoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func categoryDidChanged(_ sender: Any) {
        self.delegate?.categoryDidChange(category: categoryTextField.text)
    }
}
