//
//  TermDetailViewController.swift
//  KUtalog Lite
//
//  Created by HASAN CAN on 20.01.2020.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit

protocol TermDetailChangeDelegate {
    func courseDidChange(index: Int, newCourses: [Course])
}

class TermDetailViewController: UIViewController {
    @IBOutlet weak var termDetailTableView: UITableView!
    weak var delegate: DataSourceDelegate?
    var courses: [Course]!
    let indexInTerms: Int! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
