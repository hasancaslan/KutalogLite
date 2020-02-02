//
//  Alerts.swift
//  KUtalog Lite
//
//  Created by HASAN CAN on 19.01.2020.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit

enum AlertMessages: String {
    case loginFailed = "Provied credentials are invalid."
    case fieldsEmpty = "E-mail or password field can't be empty."
}

func createErrorAlert(message: AlertMessages, error: Error?) -> UIAlertController {
    if let error = error {
        let alert = UIAlertController(title: "Aw, Snap!", message: error.localizedDescription, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        return alert
    } else {
        let alert = UIAlertController(title: "Aw, Snap!", message: message.rawValue, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        return alert
    }
}
