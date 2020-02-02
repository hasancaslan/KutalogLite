//
//  TasksViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 2/2/20.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit

// MARK: - Types
/// An enumeration of all the types of table view sections.
enum SectionType: String, CustomStringConvertible {
    case title = "TITLE"
    case dueDate = "DUE DATE"
    case category = "CATEGORY"
    case info = "INFO"
    
    var description: String {
        return self.rawValue
    }
}

class AddTaskViewController: UIViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addTaskTableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var selectedIndexPath: IndexPath?
    var newTask = NewTask()
    var dataSource = TasksDataSource()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTaskTableView.delegate = self
        addTaskTableView.dataSource = self
        
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Actions
    @IBAction func saveTapped(_ sender: Any) {
        var alertTitle = ""
        var success = false
        if newTask.title != "" {
            dataSource.createTask(newTask)
            alertTitle = "Your task is succesfully created!"
            success = true
        } else {
            alertTitle = "Please Enter a Title"
            success = false
        }
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        self.present(alert, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - UITableViewDataSource and Delegate
extension AddTaskViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return SectionType.title.rawValue
        case 1:
            return SectionType.dueDate.rawValue
        case 2:
            return SectionType.category.rawValue
        case 3:
            return SectionType.info.rawValue
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let index = indexPath.row
        
        switch section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.titleCell) as? TitleCell
                else {return UITableViewCell()}
            cell.delegate = self
            return cell
        case 1:
            if index == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.datePickerCell) as? DatePickerCell
                    else {return UITableViewCell()}
                return cell
            } else if index == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.remindCell) as? RemindCell
                    else {return UITableViewCell()}
                cell.textLabel?.text = "Remind Me"
                cell.delegate = self
                return cell
            }
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.categoryCell) as? CategoryCell
                else {return UITableViewCell()}
            cell.delegate = self
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.infoCell) as? InfoCell
                else {return UITableViewCell()}
            cell.delegate = self
            return cell
            
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 0 {
            return indexPath
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return 150.0
        }
        return 44.0
    }
}

// MARK:- Cell Delegates
extension AddTaskViewController: RemindCellDelegate {
    func remindSwitchIsOn(_ isOn: Bool) {
        
    }
}

extension AddTaskViewController: InfoCellDelegate {
    func infoDidBeginEditing() {
        self.tableViewBottomConstraint.constant = -1 * 216.0
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        })
        self.addTaskTableView.scrollToRow(at: IndexPath(row: 0, section: 3), at: .bottom, animated: true)
    }
    
    func infoDidEndEditing() {
        self.tableViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func infoDidChange(_ infoText: String?) {
        newTask.info = infoText
    }
}

extension AddTaskViewController: TitleCellDelegate {
    func titleDidChange(title: String?) {
        newTask.title = title
    }
}

extension AddTaskViewController: CategoryCellDelegate {
    func categoryDidChange(category: String?) {
        newTask.category = category
    }
    
    
}
