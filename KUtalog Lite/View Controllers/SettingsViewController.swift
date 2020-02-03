//
//  SettingsViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 2/3/20.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit
import StoreKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var shareApp: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    private var settingsCellData: [String] {
        let setting = ["Privacy Policy", "Terms and Conditions", "Rate Us"]
        return setting
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        self.shareApp.layer.cornerRadius = 15.0
        self.logOutButton.layer.cornerRadius = 15.0
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func shareTapped(_ sender: Any) {
        
        //TODO:- APP STORE LINK
        if let url = URL(string: "https://apps.apple.com/us/app/photo-finder-for-gallery/id1482562954") {
            let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.usernameKey)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.passwordKey)
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.loginView) as? LoginViewController else { return }
        UIApplication.shared.delegate?.window??.rootViewController = controller
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = settingsCellData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.settingsCell, for: indexPath)
        cell.textLabel?.text = setting
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        switch index {
        case 0:
            if let url = URL(string: "https://kutalog.flycricket.io/privacy.html") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        case 1:
            if let url = URL(string: "https://flycricket.io/kutalog/terms.html") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        case 2:
            SKStoreReviewController.requestReview()
            
        default:
            break
        }
    }
}
