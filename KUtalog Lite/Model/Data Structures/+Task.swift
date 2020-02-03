//
//  +Task.swift
//  KUtalog
//
//  Created by HASAN CAN on 2/2/20.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import Foundation

extension Task {
    func update(with taskToUpdate: Task) {
        self.date = taskToUpdate.date
        self.category = taskToUpdate.category
        self.info = taskToUpdate.info
        self.title = taskToUpdate.title
        self.uid = taskToUpdate.uid
    }
}
