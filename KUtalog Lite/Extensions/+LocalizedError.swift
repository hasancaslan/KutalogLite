//
//  +LocalizedError.swift
//  KUtalog Lite
//
//  Created by HASAN CAN on 19.01.2020.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import Foundation

enum ClassError: Error {
    case urlError
    case networkUnavailable
    case missingData
}

extension ClassError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .urlError:
            return NSLocalizedString("Could not create a URL.", comment: "")
        case .networkUnavailable:
            return NSLocalizedString("Could not connect to the Internet.", comment: "")
        case .missingData:
            return NSLocalizedString("Could not get data from the KUSIS.", comment: "")
        }
    }
}
