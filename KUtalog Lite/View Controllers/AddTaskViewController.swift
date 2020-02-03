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
    case category = "COURSE"
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
    var calendar = Calendar(identifier: .gregorian)
    let reminderManager = ReminderManager()
    let utility = Utilities()
    var newTask = NewTask()
    var editingTask: Task?
    var dataSource = TasksDataSource()
    var reminderIsOn = false

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTaskTableView.delegate = self
        addTaskTableView.dataSource = self
        hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let task = editingTask {
            newTask = utility.convertTask(task: task)
        }
    }

     // MARK: - Helpers
    fileprivate func addReminder() {
        guard let date = newTask.date else { return }
        let components = calendar.dateComponents([.second, .minute, .hour, .day, .month, .year], from: date)
        let dateComponents = DateComponents(calendar: calendar,
                                            timeZone: .current,
                                            year: components.year,
                                            month: components.month,
                                            day: components.day,
                                            hour: components.hour,
                                            minute: components.minute,
                                            second: components.second)

        let reminder = Reminder(id: newTask.title ?? "",
                                title: newTask.title ?? "",
                                detail: newTask.info ?? "",
                                date: dateComponents,
                                photoThumbnail: nil)

        reminderManager.reminder = reminder
        reminderManager.schedule()
    }

    // MARK: - Actions
    @IBAction func saveTapped(_ sender: Any) {
        var alertTitle = ""
        var success = false

        if newTask.title != "" && newTask.title != nil {
            if newTask.date == nil {
                newTask.date = Date()
            }

            if let taskToDelete = editingTask {
                dataSource.deleteTask(taskToDelete)
                alertTitle = "Your task is succesfully edited."
            } else {
                alertTitle = "Your task is succesfully created!"
            }

            if reminderIsOn {
                addReminder()
            }

            dataSource.createTask(newTask)
            success = true
        } else {
            alertTitle = "Please Enter a Title"
            success = false
        }

        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }))

        self.present(alert, animated: true)
    }
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
            cell.titleTextField.tag = section
            cell.titleTextField.text = editingTask?.title
            cell.delegate = self
            cell.titleTextField.delegate = self
            return cell
        case 1:
            if index == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.datePickerCell) as? DatePickerCell
                    else {return UITableViewCell()}
                cell.savedDate = editingTask?.date
                cell.delegate = self
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
            cell.categoryTextField.text = editingTask?.category
            cell.categoryTextField.tag = section
            cell.categoryTextField.delegate = self
            return cell

        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.infoCell) as? InfoCell
                else {return UITableViewCell()}
            cell.infoTextField.text = editingTask?.info
            cell.delegate = self
            return cell

        default:
            return UITableViewCell()
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = tableView.cellForRow(at: indexPath) as? TitleCell else { return }
            cell.titleTextField.becomeFirstResponder()

        case 1:
            if indexPath.row == 0 {
                guard let cell = tableView.cellForRow(at: indexPath) as? DatePickerCell else { return }
                cell.textField.becomeFirstResponder()
            }

        case 2:
            guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell else { return }
            cell.categoryTextField.becomeFirstResponder()

        case 3:
            guard let cell = tableView.cellForRow(at: indexPath) as? InfoCell else { return }
            cell.infoTextField.becomeFirstResponder()

        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return 150.0
        }
        return 44.0
    }
}

// MARK: - Cell Delegates
extension AddTaskViewController: RemindCellDelegate {
    func remindSwitchIsOn(_ isOn: Bool) {
        self.reminderIsOn = isOn
    }
}

extension AddTaskViewController: DatePickerCellDelegate {
    func didDateChanged(date: Date) {
        self.newTask.date = date
    }

    func didTapDoneDate(date: Date) {
        self.newTask.date = date
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

// MARK: - UITextFieldDelegate
extension AddTaskViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let section = textField.tag
        let indexPath = IndexPath(row: 0, section: section)
        self.addTaskTableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        return true
    }
}
