//
//  +DateFormatter.swift
//  KUtalog
//
//  Created by HASAN CAN on 2/2/20.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import Foundation

extension DateFormatter {

    /// - returns: A string representation of date using the short date style.
    class func short(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEEE, MMMM dd"
        return dateFormatter.string(from: date)
    }

    /// - returns: A string representation of hour.
    class func hour(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
