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
    var dataSource = CourseDataSource()
    let utility = Utilities()
    @IBOutlet weak var courseHistoryTableView: UITableView!
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var gpaLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        courseHistoryTableView.delegate = self
        courseHistoryTableView.dataSource = self
        dataSource.delegate = self
        setNavigationBar()
        addRefreshControl()
        gpaLabel.layer.cornerRadius = 5
        creditsLabel.layer.cornerRadius = 5
        courseHistoryTableView.rowHeight = 54

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
        UserDefaults.standard.set(storage, forKey: UserDefaultsKeys.storageKey)
    }

    fileprivate func fetchStorage() -> [[Course]]? {
        if let storage = UserDefaults.standard.object(forKey: UserDefaultsKeys.storageKey) as? NSString {
            return utility.readJson(from: storage)
        } else {
            return nil
        }
    }

    fileprivate func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.babyPowder
        refreshControl.addTarget(self, action: #selector(CourseHistoryViewController.refresh(_:)), for: UIControl.Event.valueChanged)
        courseHistoryTableView.refreshControl = refreshControl
    }

    func setGpaAndCredits(_ sortedTerms: [[Course]]) {
        let gpa = utility.calculateGPA(sortedTerms)
        if gpa >= 0.0 {
            gpaLabel.text = String(format: "  GPA: %.2f  ", gpa)
        } else {
            gpaLabel.text = "  GPA: -  "
        }
        
        let credits = utility.calculateTotalCredits(sortedTerms)
        if credits >= 0.0 {
            creditsLabel.text = String(format: "  Credits: %.0f  ", credits)
        } else {
            creditsLabel.text = "  Credits: -  "
        }
    }
    
    fileprivate func reloadTerms(with termList: [[Course]]) {
        let sortedTerms = utility.sortTerms(termList)
        terms = sortedTerms
        updateStorage(with: sortedTerms)
        setGpaAndCredits(sortedTerms)
        courseHistoryTableView.reloadData()
    }

    @objc func refresh(_ sender: AnyObject) {
        guard let username = UserDefaults.standard.string(forKey: UserDefaultsKeys.usernameKey),
            let password = UserDefaults.standard.string(forKey: UserDefaultsKeys.passwordKey) else {
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

    func setNavigationBar() {
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
        if let destination = segue.destination as? TermDetailViewController {
            guard let cell = sender as? UITableViewCell else { return }
            if let indexPath = courseHistoryTableView.indexPath(for: cell) {
                let index = indexPath.row
                destination.courses = terms?[index]
                destination.indexInTerms = index
                destination.delegate = self
            }
        }
    }
}

// MARK: - UITableViewDelegate and DataSource
extension CourseHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.courseHistoryCell, for: indexPath) as UITableViewCell
        guard let termList = terms else {
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            cell.isUserInteractionEnabled = false
            return cell
        }

        let spa = utility.calculateSPA(termList[indexPath.row])
        if spa >= 0.0 {
            cell.detailTextLabel?.text = String(format: "%.2f", spa)
        } else {
            cell.detailTextLabel?.text = "-"
        }

        cell.textLabel?.text = termList[indexPath.row][0].term
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.courseHistoryTableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - DataSourceDelegate
extension CourseHistoryViewController: CourseDataSourceDelegate {
    func termListLoaded(termList: [[Course]]) {
        self.reloadTerms(with: termList)
        self.refreshControl.endRefreshing()
        onAdd()
    }
}

// MARK: - TermDetail Change Delegate
extension CourseHistoryViewController: TermDetailDelegate {
    func coursesDidChange(index: Int, newCourses: [Course]) {
        if var newTerms = terms {
            newTerms[index] = newCourses
            reloadTerms(with: newTerms)
        }
    }
}
