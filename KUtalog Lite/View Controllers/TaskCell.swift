//
//  TaskCell.swift
//  KUtalog
//
//  Created by HASAN CAN on 2/2/20.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//
import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func deleteTapped(task: Task?)
}

class TaskCell: UITableViewCell {
    weak var delegate: TaskTableViewCellDelegate?
    var task: Task?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var courseCodeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var descriptionLabelHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
        courseCodeLabel.text = ""
        timeLabel.text = ""
        descriptionLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        courseCodeLabel.text = ""
        timeLabel.text = ""
        descriptionLabel.text = ""
        descriptionLabelHeightAnchor.constant = 0
        delegate = nil
        task = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func configure(task: Task?, background: UIColor) {
        self.task = task
        self.contentView.backgroundColor = background
        self.topView.backgroundColor = background
        if let title = task?.title {
            titleLabel.text = title
        }
        if let category = task?.category {
            courseCodeLabel.text = category
        }
        if let date = task?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE HH:mm"
            timeLabel.text = dateFormatter.string(from: date)
        }
        if let info = task?.info {
            descriptionLabel.text = info
            if info != "" {
                descriptionLabelHeightAnchor.constant = info.height(withConstrainedWidth:
                    self.contentView.frame.width - 40, font: .systemFont(ofSize: 12))
            }
        }
    }
    
    @IBAction func deleteTap(_ sender: Any) {
        self.delegate?.deleteTapped(task: task)
    }
}
