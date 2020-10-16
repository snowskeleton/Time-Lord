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
                self.scheduleNotifications()
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
                self.scheduleNotifications()
            default:
                break // Do nothing
            }
        }
    }

    private func scheduleNotifications() {
        for notif in notifications {
            if notif.repeating != [false, false, false, false, false, false, false] { //if not repeating on any day
                for id in notif.ids {
                    if notif.repeating[notif.ids.firstIndex(of: id)!] == true {
                        print(notif.repeating[notif.ids.firstIndex(of: id)!])
                        let content      = UNMutableNotificationContent()
                        content.title    = notif.title
                        content.sound    = .default

                        var day = notif.datetime
                        day.weekday = notif.ids.firstIndex(of: id)! //add the specific weekday to the DateComponents

                        let trigger = UNCalendarNotificationTrigger(dateMatching: day, repeats: true)

                        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

                        UNUserNotificationCenter.current().add(request) { error in

                            guard error == nil else { return }

                            print("Notification scheduled! --- ID = \(id)")
                        }
                    }
                }
            } else {
                let content      = UNMutableNotificationContent()
                content.title    = notif.title
                content.sound    = .default

                let trigger = UNCalendarNotificationTrigger(dateMatching: notif.datetime, repeats: false)

                let request = UNNotificationRequest(identifier: notif.ids[0], content: content, trigger: trigger) //use the first notif id if not repeating. not super clean, but not sure what else to do.

                UNUserNotificationCenter.current().add(request) { error in

                    guard error == nil else { return }

                    print("Notification scheduled! --- ID = \(notif.ids[0])")
                }
            }
        }
    }

}
