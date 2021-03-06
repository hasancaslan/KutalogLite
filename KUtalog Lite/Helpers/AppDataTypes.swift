//
//  AppDataTypes.swift
//  KUtalog
//
//  Created by HASAN CAN on 2/2/20.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit

// MARK: - Table View Cells

/// A structure that specifies Table Vİew Cell idetifiers
struct CellIdentifiers {
    static let taskCell = "taskCell"
    static let courseCell = "courseCell"
    static let titleCell = "titleCell"
    static let datePickerCell = "datePickerCell"
    static let remindCell = "remindCell"
    static let categoryCell = "categoryCell"
    static let infoCell = "infoCell"
    static let courseHistoryCell = "courseHistoryCell"
    static let settingsCell = "SettingsCell"
}

// MARK: - Cell Color Palette

struct CellColors {
    static let backgrounColors = [UIColor(hexString: "f45905"), UIColor(hexString: "fb9224"), UIColor(hexString: "b83b5e"), UIColor(hexString: "2a1a5e")]
}

// MARK: - View Controllers

/// A structure that specifies all the view controller identifiers.
struct ViewControllerIdentifiers {
    static let loginView = "LoginViewController"
    static let courseHistoryView = "CourseHistoryViewController"
    static let termDetailView = "TermDetailViewController"
    static let addTaskView = "AddTaskViewController"
    static let tasksView = "TasksViewController"
}

// MARK: - User Defaults

/// A structure that specifies all the UserDefaults keys.
struct UserDefaultsKeys {
    static let usernameKey = "username"
    static let passwordKey = "password"
    static let storageKey = "storage"
}
