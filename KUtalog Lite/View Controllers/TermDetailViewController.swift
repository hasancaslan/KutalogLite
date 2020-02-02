//
//  TermDetailViewController.swift
//  KUtalog Lite
//
//  Created by HASAN CAN on 20.01.2020.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit

protocol TermDetailDelegate: AnyObject {
    func coursesDidChange(index: Int, newCourses: [Course])
}

class TermDetailViewController: UIViewController {
    @IBOutlet weak var termDetailTableView: UITableView!
    @IBOutlet weak var spaLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    let utility = Utilities()
    weak var delegate: TermDetailDelegate?
    var courses: [Course]!
    var indexInTerms: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        termDetailTableView.dataSource = self
        setSpaAndCreditLabels()
        setNavigationTitle()
        spaLabel.layer.cornerRadius = 5
        creditsLabel.layer.cornerRadius = 5
        termDetailTableView.rowHeight = 54
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        delegate?.coursesDidChange(index: indexInTerms, newCourses: courses)
    }

    func setSpaAndCreditLabels() {
        let spa = utility.calculateSPA(courses)
        let credits = utility.calculateSemesterCredits(courses)

        if spa >= 0 {
            spaLabel.text = String(format: "  SPA: %.2f  ", spa)
        } else {
            spaLabel.text = String(format: "  SPA: -  ")
        }

        if credits >= 0 {
            creditsLabel.text = String(format: "  Credits: %.0f  ", credits)
        } else {
             creditsLabel.text = String(format: "  Credits: -  ")
        }
    }

    func setNavigationTitle() {
        let titleLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        titleLabel.text = courses[0].term
        titleLabel.font =  UIFont.systemFont(ofSize: 25, weight: .light)
        titleLabel.textColor = UIColor.white
        self.navigationItem.title = courses[0].term
    }

    func reloadView() {
        setSpaAndCreditLabels()
        termDetailTableView.reloadData()
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

// MARK: - UITableViewDataSource
extension TermDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.courseCell) as? CourseCell else { return UITableViewCell() }
        let index = indexPath.row
        cell.title.text = courses[index].name
        cell.detail.text = String(format: "%.0f", courses[index].units)
        cell.textField.text = courses[index].grade
        cell.index = index
        cell.delegate = self
        return cell
    }
}

// MARK: - CourseCell Change Delegate
extension TermDetailViewController: CourseCellDelegate {
    func didPlusClicked(index: Int) {
        switch courses[index].grade {
        case "A+":
            courses[index].grade = "W"
            courses[index].wunit = courses[index].units
            courses[index].units = 0.0
        case "A":
            courses[index].grade="A+"
            courses[index].point = 4.3
        case "A-":
            courses[index].grade = "A"
            courses[index].point = 4.0
        case "B+":
            courses[index].grade = "A-"
            courses[index].point = 3.7
        case "B":
            courses[index].grade = "B+"
            courses[index].point = 3.3
        case "B-":
            courses[index].grade = "B"
            courses[index].point = 3.0
        case "C+":
            courses[index].grade = "B-"
            courses[index].point = 2.7
        case "C":
            courses[index].grade = "C+"
            courses[index].point = 2.3
        case "C-":
            courses[index].grade = "C"
            courses[index].point = 2.0
        case "D+":
            courses[index].grade = "C-"
            courses[index].point = 1.7
        case "D":
            courses[index].grade = "D+"
            courses[index].point = 1.3
        case "F":
            courses[index].grade = "D"
            courses[index].point = 1.0
        case "W":
            courses[index].grade = "F"
            courses[index].point = 0.0
            courses[index].units = courses[index].wunit
        default:
            courses[index].grade = "F"
            courses[index].point = 0.0
            courses[index].units = courses[index].wunit
            courses[index].valid = 1
        }
        reloadView()
    }

    func didMinusClicked(index: Int) {
        switch courses[index].grade {
        case "A+":
            courses[index].grade = "A"
            courses[index].point = 4.0
        case "A":
            courses[index].grade = "A-"
            courses[index].point = 3.7
        case "A-":
            courses[index].grade = "B+"
            courses[index].point = 3.3
        case "B+":
            courses[index].grade = "B"
            courses[index].point = 3.0
        case "B":
            courses[index].grade = "B-"
            courses[index].point = 2.7
        case "B-":
            courses[index].grade = "C+"
            courses[index].point = 2.3
        case "C+":
            courses[index].grade = "C"
            courses[index].point = 2.0
        case "C":
            courses[index].grade = "C-"
            courses[index].point = 1.7
        case "C-":
            courses[index].grade = "D+"
            courses[index].point = 1.3
        case "D+":
            courses[index].grade = "D"
            courses[index].point = 1.0
        case "D":
            courses[index].grade = "F"
            courses[index].point = 0
        case "F":
            courses[index].grade = "W"
            courses[index].wunit =  courses[index].units
            courses[index].units = 0.0
        case "W":
            courses[index].grade = "A+"
            courses[index].point = 4.3
            courses[index].units = courses[index].wunit
        default:
            courses[index].grade = "A+"
            courses[index].point = 4.3
            courses[index].units = courses[index].wunit
            courses[index].valid = 1
        }
        reloadView()
    }
}
