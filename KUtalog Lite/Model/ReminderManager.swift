//
//  ReminderManager.swift
//  KUtalog
//
//  Created by HASAN CAN on 2/3/20.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import UIKit
import UserNotifications

struct Reminder {
    var id: String
    var title: String
    var detail: String
    var date: DateComponents
    var photoThumbnail: UIImage?
}

class ReminderManager {
    var reminder: Reminder?

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
    }

    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                print(notification)
            }
        }
    }

    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break // Do nothing
            }
        }
    }

    private func scheduleNotifications() {
        let content = UNMutableNotificationContent()

        if let currentNotification = self.reminder {
            content.title = currentNotification.title
            content.body = currentNotification.detail
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: currentNotification.date, repeats: false)
            let request = UNNotificationRequest(identifier: currentNotification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Notification scheduled! --- ID = \(currentNotification.id)\n\(currentNotification.date)")
            }

        }

    }
}
