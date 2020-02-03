//
//  AppProtocols.swift
//  KUtalog
//
//  Created by HASAN CAN on 2/2/20.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit

// MARK: - DiscloseView

protocol DiscloseView {
    func show()
    func hide()
}

// MARK: - EnableItem

protocol EnableItem {
    func enable()
    func disable()
}

extension UIBarItem: EnableItem {
    /// Enable the bar item.
    func enable() {
        self.isEnabled = true
    }

    /// Disable the bar item.
    func disable() {
        self.isEnabled = false
    }
}
