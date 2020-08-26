//
//  TimetableViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 2/3/20.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit

class TimetableViewController: UIViewController {

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
