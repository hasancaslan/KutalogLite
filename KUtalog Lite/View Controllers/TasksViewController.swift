//
//  TasksViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 2/2/20.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit
import CoreData

class TasksViewController: UIViewController {
    @IBOutlet weak var tasksTableView: UITableView!
    
    // MARK: - Properties
    var selectedRowIndex = -1
    var thereIsCellTapped = false
    var allTasks: [Task]? = [Task]()
    private lazy var dataSource: TasksDataSource = {
        let source = TasksDataSource()
        source.fetchedResultsControllerDelegate = self
        source.delegate = self
        return source
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.loadListOfTasks()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        selectedRowIndex = -1
    }
    
    // MARK: - Helpers
    fileprivate func setNavigationBar() {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.babyPowder]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.babyPowder]
            navBarAppearance.backgroundColor = UIColor.maastrichtBlue
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            self.navigationController?.navigationBar.compactAppearance = navBarAppearance
        } else {
            self.navigationController?.navigationBar.backgroundColor = UIColor.maastrichtBlue
            self.navigationController?.navigationBar.isTranslucent = false
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTaskSegue" {
            guard let destination = segue.destination as? AddTaskViewController else { return }
            if selectedRowIndex >= 0 {
                destination.editingTask = allTasks?[selectedRowIndex]
            }
        }
    }
}

// MARK: - TaskTableViewCellDelegate
extension TasksViewController: TaskTableViewCellDelegate {
    func deleteTapped(task: Task?) {
        if let taskToDelete = task {
            dataSource.deleteTask(taskToDelete)
        }
    }
}

// MARK: - UITableViewDelegate
extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedRowIndex && thereIsCellTapped {
            if let cell = tableView.cellForRow(at: indexPath) as? TaskCell {
                return 120 + cell.descriptionLabel.frame.height
            }
            return 120
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasksTableView.cellForRow(at: indexPath)?.backgroundColor = .gray
        if self.selectedRowIndex != -1 {
            tasksTableView.cellForRow(at: IndexPath(row: selectedRowIndex, section: 0))?.backgroundColor = .white
        }
        if selectedRowIndex != indexPath.row {
            self.thereIsCellTapped = true
            self.selectedRowIndex = indexPath.row
        } else {
            // there is no cell selected anymore
            self.thereIsCellTapped = false
            self.selectedRowIndex = -1
        }
        tasksTableView.beginUpdates()
        tasksTableView.endUpdates()
    }
}

// MARK: - UITableViewDataSource
extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.taskCell) as? TaskCell {
            let fetchedObjects = dataSource.fetchedResultsController.fetchedObjects
            let count = Int(Double(indexPath.row).truncatingRemainder(dividingBy: Double(CellColors.backgrounColors.count)))
            let background = CellColors.backgrounColors[count]
            cell.configure(task: fetchedObjects?[indexPath.row], background: background)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TasksViewController: NSFetchedResultsControllerDelegate {
    /**
     Reloads the table view when the fetched result controller's content changes.
     */
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tasksTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tasksTableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tasksTableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tasksTableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: tasksTableView.insertSections(indexSet, with: .fade)
        case .delete: tasksTableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        @unknown default:
            return
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tasksTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tasksTableView.endUpdates()
    }
    
}

// MARK: - TasksDataSourceDelegate
extension TasksViewController: TasksDataSourceDelegate {
    func taskListLoaded(taskList: [Task]?) {
        self.allTasks = taskList
        tasksTableView.reloadData()
        tasksTableView.beginUpdates()
        tasksTableView.endUpdates()
    }
}
