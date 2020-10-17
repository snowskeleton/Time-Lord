//
//  LocalNotificationManager.swift
//  Time Lord
//
//  Created by Isaac Lyons on 10/15/20.
//

import Foundation
import SwiftUI
import UserNotifications

class LocalNotificationManager {
    var notifications = [Notification]()

    struct Notification {
        var ids:[String]
        var title:String
        var datetime:DateComponents
        var repeating:[Bool]
    }

    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in

            if granted == true && error == nil {
                self.prepareNotification()
            }
        }
    }

    func listScheduledNotifications() { //for debugging
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
                self.prepareNotification()
            default:
                break // Do nothing
            }
        }
    }

    private func prepareNotification() {
        for notif in notifications {
            let content      = UNMutableNotificationContent()
            content.title    = notif.title
            content.sound    = .default

            if notif.repeating != [false, false, false, false, false, false, false] { //if not repeating on any day
                for id in notif.ids {
                    if notif.repeating[notif.ids.firstIndex(of: id)!] == true {
                        var day = notif.datetime
                        day.weekday = notif.ids.firstIndex(of: id)! //add the specific weekday to the DateComponents

                        let trigger = UNCalendarNotificationTrigger(dateMatching: day, repeats: true)
                        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                        scheduleNotification(request)
                    }
                }
            } else {
                let trigger = UNCalendarNotificationTrigger(dateMatching: notif.datetime, repeats: false)
                let request = UNNotificationRequest(identifier: notif.ids[0], content: content, trigger: trigger) //use the first notif id if not repeating. not super clean, but not sure what else to do.
                scheduleNotification(request)
            }
        }
    }

    private func scheduleNotification(_ request: UNNotificationRequest) {
        UNUserNotificationCenter.current().add(request) { error in
            guard error == nil else { return }
        }
    }

}
