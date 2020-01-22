//
//  CourseCell.swift
//  KUtalog Lite
//
//  Created by HASAN CAN on 21.01.2020.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var plus: UIButton!
    @IBOutlet var textField: UILabel!
    @IBOutlet var minus: UIButton!
    @IBOutlet var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
