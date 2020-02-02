//
//  CourseCell.swift
//  KUtalog Lite
//
//  Created by HASAN CAN on 21.01.2020.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit

protocol CourseCellDelegate {
    func didPlusClicked(index: Int)
    func didMinusClicked(index: Int)
}

class CourseCell: UITableViewCell {
    @IBOutlet weak var gradeView: UIView!
    @IBOutlet var title: UILabel!
    @IBOutlet var plus: UIButton!
    @IBOutlet var textField: UILabel!
    @IBOutlet var minus: UIButton!
    @IBOutlet var detail: UILabel!
    var index: Int!
    var delegate: CourseCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        gradeView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func minusClicked(_ sender: Any) {
        delegate?.didMinusClicked(index: index)
    }

    @IBAction func plusClicked(_ sender: Any) {
        delegate?.didPlusClicked(index: index)
    }
}
