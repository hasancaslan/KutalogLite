//
//  CourseHistoryViewController.swift
//  KUtalog Lite
//
//  Created by HASAN CAN on 20.01.2020.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit

class CourseHistoryViewController: UIViewController {
    var terms: [[Course]]?
    var dataSource = DataSource()
    let utility = Utilities()
    var credit = 0.0
    @IBOutlet weak var courseHistoryTableView: UITableView!
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var gpaLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        courseHistoryTableView.delegate = self
        courseHistoryTableView.dataSource = self
        dataSource.delegate = self
        addRefreshControl()
        if terms == nil {
            if let fetchedTerms = fetchStorage() {
                reloadTerms(with: fetchedTerms)
            }
        } else {
            reloadTerms(with: terms!)
        }
    }

    // MARK: - Helpers
    fileprivate func updateStorage(with terms: [[Course]]) {
        let storage = utility.toJson(from: terms) as NSString
        UserDefaults.standard.set(storage, forKey: "storage")
    }

    fileprivate func fetchStorage() -> [[Course]]? {
        if let storage = UserDefaults.standard.object(forKey: "storage") as? NSString {
            return utility.readJson(from: storage)
        } else {
            return nil
        }
    }

    fileprivate func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(CourseHistoryViewController.refresh(_:)), for: UIControl.Event.valueChanged)
        courseHistoryTableView.refreshControl = refreshControl
    }

    fileprivate func reloadTerms(with termList: [[Course]]) {
        terms = termList
        updateStorage(with: termList)
        let gpa = utility.calculateGPA(termList)
        if gpa >= 0.0 {
            gpaLabel.text = String(format: "GPA: %.2f", gpa)
        } else {
            gpaLabel.text = "GPA: -"
        }

        //            credit = utility.calculateCredits()
        courseHistoryTableView.reloadData()
    }

    @objc func refresh(_ sender: AnyObject) {
        guard let username = UserDefaults.standard.string(forKey: "username"),
            let password = UserDefaults.standard.string(forKey: "password") else {
                let alert = createErrorAlert(message: .fieldsEmpty, error: nil)
                self.present(alert, animated: true, completion: nil)
                return
        }

        dataSource.loadCourseHistory(name: username, password: password, completionHandler: { error in
            if let error = error {
                self.refreshControl.endRefreshing()
                let alert = createErrorAlert(message: .loginFailed, error: error)
                self.present(alert, animated: true, completion: nil)
                return
            }
        })
    }

    func onAdd() {
        let inset = self.courseHistoryTableView.contentInset
        self.courseHistoryTableView.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        self.courseHistoryTableView.contentInset = inset
    }

// MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      Get the new view controller using segue.destination.
      Pass the selected object to the new view controller.
     }
}

// MARK: - UITableView Delegate and Data Source
extension CourseHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseHistoryCell", for: indexPath) as UITableViewCell

        //        //      if indexPath.row == 0 {
        //        if gpa >= 0.0 {
        //            cell.textLabel?.text = String(format: "GPA: %.2f", gpa)
        //        } else {
        //            cell.textLabel?.text = "-"
        //        }
        //        cell.backgroundColor = UIColor.lightGray
        //        cell.tintColor = UIColor.white
        //        cell.textLabel?.font = UIFont.systemFont(ofSize: 19)
        //        cell.detailTextLabel?.text = String(format: "Credit: %.0f", credit)
        //        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        //        cell.isUserInteractionEnabled = false
        //    } else {
        guard let termList = terms else {
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            cell.isUserInteractionEnabled = false
            return cell
        }

        let spa = utility.calculateSPA(termList[indexPath.row])
        cell.textLabel?.text = termList[indexPath.row][0].term
        if spa >= 0.0 {
            cell.detailTextLabel?.text = String(format: "%.2f", spa)
        } else {
            cell.detailTextLabel?.text = "-"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.courseHistoryTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CourseHistoryViewController: DataSourceDelegate {
    func termListLoaded(termList: [[Course]]) {
        self.reloadTerms(with: termList)
        self.refreshControl.endRefreshing()
        onAdd()
    }
}

extension CourseHistoryViewController: TermDetailChangeDelegate {
    func courseDidChange(index: Int, newCourses: [Course]) {
        if var newTerms = terms {
            newTerms[index] = newCourses
            reloadTerms(with: newTerms)
            updateStorage(with: newTerms)
        }
    }
}