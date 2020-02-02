//
//  DateCell.swift
//  KUtalog
//
//  Created by HASAN CAN on 2/2/20.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit

protocol RemindCellDelegate {
    func remindSwitchIsOn(_ isOn: Bool)
}

class RemindCell: UITableViewCell {
    @IBOutlet weak var remindSwitch: UISwitch!
    var delegate: RemindCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchDidChanged(_ sender: Any) {
        self.delegate?.remindSwitchIsOn(remindSwitch.isOn)
    }
}
