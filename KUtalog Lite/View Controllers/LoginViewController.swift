//
//  LoginViewController.swift
//  KUtalog Lite
//
//  Created by HASAN CAN on 19.01.2020.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit
import TextFieldEffects

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: MadokaTextField!
    @IBOutlet weak var passwordField: MadokaTextField!
    @IBOutlet weak var loginButton: UIButton!
    var dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        hideKeyboardWhenTappedAround()
        loginButton.layer.cornerRadius = 55/2
    }
    
    // MARK: - Actions
    @IBAction func loginTapped(_ sender: Any) {
        let activityIndicator: UIActivityIndicatorView = {
            let activity = UIActivityIndicatorView()
            activity.translatesAutoresizingMaskIntoConstraints = false
            activity.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            activity.startAnimating()
            return activity
        }()
        
        loginButton.setTitle(nil, for: .normal)
        loginButton.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor).isActive = true
        
        guard let username = emailField.text, let password = passwordField.text else {
            let alert = createErrorAlert(message: .fieldsEmpty, error: nil)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        dataSource.loadCourseHistory(name: username, password: password, completionHandler: { error in
            if let error = error {
                activityIndicator.stopAnimating()
                self.loginButton.setTitle("Log In", for: .normal)
                activityIndicator.removeFromSuperview()
                let alert = createErrorAlert(message: .loginFailed, error: error)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.set(password, forKey: "password")
        })
    }
    
    // MARK: - Helpers
    func navigateToCourseHistory(_ termList: [[Course]]) {
        if let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController,
            let navigationController = tabBarController.viewControllers?.first as? UINavigationController,
            let courseHistoryVC = navigationController.viewControllers.first as? CourseHistoryViewController {
                courseHistoryVC.terms = termList
            tabBarController.selectedIndex = 0
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = tabBarController
        }
    }
}

extension LoginViewController: DataSourceDelegate {
    func termListLoaded(termList: [[Course]]) {
        navigateToCourseHistory(termList)
    }
}
