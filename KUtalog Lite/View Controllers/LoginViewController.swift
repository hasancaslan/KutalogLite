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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        loginButton.layer.cornerRadius = 55/2
    }
    
    
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

              guard let email = emailField.text, let password = passwordField.text else {
                  let alert = createErrorAlert(message: .fieldsEmpty, error: nil)
                  self.present(alert, animated: true, completion: nil)
                  return
              }

//              Auth.auth().signIn(withEmail: email, password: password) {[unowned self] (user, err) in
//                  if err != nil {
//                      activityIndicator.stopAnimating()
//                      self.loginButton.setTitle("Log In", for: .normal)
//                      activityIndicator.removeFromSuperview()
//                      let alert = createErrorAlert(message: .loginFailed, error: nil)
//                      self.present(alert, animated: true, completion: nil)
//                      return
//                  }
//
//                  let uid = user?.user.uid
//                  UserDefaults.standard.set(email, forKey: "email")
//                  UserDefaults.standard.set(password, forKey: "password")
//                  UserDefaults.standard.set(uid, forKey: "uid")
//
//                  let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
//                  let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                  appDelegate.window?.rootViewController = controller
//              }
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
