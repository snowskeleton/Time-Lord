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
        var ids: [String]
        var title: String
        var datetime: DateComponents
        var repeating: [Bool]
        var isSingle: Bool {
            if repeating == [false, false, false, false, false, false, false] {
                return true
            } else {
                return false
            }
        }
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

            if notif.isSingle { //if not repeating on any day
                for id in notif.ids {
                    let selectedDay = notif.ids.firstIndex(of: id)!
                    if notif.repeating[selectedDay] {
                        var day = notif.datetime
                        day.weekday = selectedDay + 1 //add the specific weekday to the DateComponents //plus 1 to make array counting match up with weekday counting. Monday is 2

                        let trigger = UNCalendarNotificationTrigger(dateMatching: day, repeats: true)
                        scheduleNotification(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
                    } else {
                        LocalNotificationManager().removeNotifications([id]) //else remove any notifications set for that day. probably not necessary, but I don't have enough confidance in the rest of my code.
                    }
                }
            } else {
                let trigger = UNCalendarNotificationTrigger(dateMatching: notif.datetime, repeats: false)
                scheduleNotification(UNNotificationRequest(identifier: notif.ids[0], content: content, trigger: trigger))
            }
        }
    }

    private func scheduleNotification(_ request: UNNotificationRequest) {
        UNUserNotificationCenter.current().add(request) { error in
            guard error == nil else { return }
        }
    }

    func removeNotifications(_ ids: [String]) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ids)
    }

}
