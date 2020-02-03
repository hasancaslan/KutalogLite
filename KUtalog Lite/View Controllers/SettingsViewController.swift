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

    // MARK: - Data Source
    private var settingsCellData: [String] {
        let setting = ["Privacy Policy", "Terms and Conditions", "Rate Us"]
        return setting
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        self.shareApp.layer.cornerRadius = 15.0
        self.logOutButton.layer.cornerRadius = 15.0
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

// MARK: - UITableViewDataSource and Delegate
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
