//  EditAlarmView.swift
//  Time Lord
//
//  Created by Isaac Lyons on 9/30/20.
//

import SwiftUI

struct EditAlarmView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc

    @State private var alarm: Alarm?
    @State var befores: [Int] = []
    @State var afters: [Int] = []
    @State private var time = Date()
    var hours: Int {
        let actualTime = Calendar.current.dateComponents([.hour, .minute], from: time)
        return actualTime.hour!
    }
    var minutes: Int {
        let actualTime = Calendar.current.dateComponents([.hour, .minute], from: time)
        return actualTime.minute!
    }
    @State private var name: String = ""
    @State private var snooze = false
    @State var daysOfWeek: [Bool] = [false, false, false, false, false, false, false]
    @State private var showDaysPicker = false

    init(alarm: Binding<Alarm>) {
        _alarm = State(initialValue: alarm.wrappedValue)
        _befores = State(initialValue: (alarm.wrappedValue).beforeInts())
        _afters = State(initialValue: (alarm.wrappedValue).afterInts())
        let calendar = Calendar.current
        let components = DateComponents(
            hour: Int(alarm.hours.wrappedValue),
            minute: Int(alarm.minutes.wrappedValue))
        _time = State(initialValue: calendar.date(from: components)!)
        _name = State(initialValue: alarm.name.wrappedValue ?? "")
        _daysOfWeek = State<[Bool]>(initialValue: alarm.daysOfWeek.wrappedValue!)
    }
    init() { }

    var body: some View {
        NavigationView {
            VStack {

                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }.padding()
                    Spacer()
                    Button("Save") {
                        save()
                        presentationMode.wrappedValue.dismiss()
                    }.padding(.trailing)
                }

                DatePicker("Date",
                           selection: $time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()

                Form {

                    NavigationLink(destination: DayOfTheWeekPicker(activeDays: $daysOfWeek)) {
                        HStack {
                            Text("Repeat")
                        }
                    }

                    TextField("Name", text: $name)

                    NavigationLink(destination: EditRoutineView(befores: $befores, afters: $afters)) {
                        HStack {
                            Text("Routines")
                            Text(beforesAndAftersAsString())
                        }
                    }

                    if alarm != nil {
                        Section {
                            Button(action: {
                                let notifIDs = alarm!.notificationIDs
                                LocalNotificationManager().removeNotifications(notifIDs!)
                                self.moc.delete(alarm!)
                                try? self.moc.save()
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Delete")
                                        .foregroundColor(Color.red)
                                    Spacer()
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    fileprivate func save() {
        var alarm: Alarm
        if self.alarm != nil {
            alarm = self.alarm!
            let notifIDs = alarm.allNotificationIDs()
            LocalNotificationManager().removeNotifications(notifIDs)
        } else {
            alarm = Alarm(context: self.moc)
            alarm.id = UUID().uuidString
        }

        alarm.notificationIDs = { () -> [String] in
            var set: [String] = []
            for _ in 0...6 {
                let id = UUID().uuidString
                set.append(id)
            }
            return set
        }()
        alarm.daysOfWeek = daysOfWeek
        alarm.active = true
        alarm.name = name
        let actualTime = Calendar.current.dateComponents([.hour, .minute], from: time)
        alarm.hours = Int64(actualTime.hour!)
        alarm.minutes = Int64(actualTime.minute!)

        alarm.befores = nil
        for i in befores {
            let before = Before(context: self.moc)
            before.offset = Int64(i)
            before.notificationID = UUID().uuidString
            before.alarm = alarm
        }
        alarm.afters = nil
        for i in afters {
            let after = After(context: self.moc)
            after.offset = Int64(i)
            after.notificationID = UUID().uuidString
            after.alarm = alarm
        }

        try? self.moc.save()

        updateNotification(alarm)
    }

    public func updateNotification(_ alarm: FetchedResults<Alarm>.Element) {
        let manager = LocalNotificationManager()
        manager.notifications = [
            LocalNotificationManager.Notification(
                ids: alarm.notificationIDs!,
                title: (alarm.name == "" ? "Alarm" : alarm.name)!,
                datetime: DateComponents(
                    calendar: Calendar.current,
                    hour: Int(alarm.hours),
                    minute: Int(alarm.minutes)),
                repeating: alarm.daysOfWeek!)
        ]
        manager.schedule()
    }

    func beforesAndAftersAsString() -> String {
        var thing: [String] = []

        var i = 0
        count: for before in befores {
            if i < 3 {
                thing.append("\(before)")
            } else {
                thing.append("...")
                break count
            }
            i += 1
        }

        i = 0
        count: for after in afters {
            if i < 3 {
                thing.append("+\(after)")
            } else {
                thing.append("...")
                break count
            }
            i += 1
        }
        return thing.joined(separator: ", ")
    }

}
