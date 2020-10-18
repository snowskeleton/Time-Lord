//  EditAlarmView.swift
//  Time Lord
//
//  Created by Isaac Lyons on 9/30/20.
//

import SwiftUI

struct EditAlarmView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Routine.entity(), sortDescriptors: []) var routines: FetchedResults<Routine>


    @State private var alarm: Alarm?
//    @State private var routines: [Routine]
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
        let calendar = Calendar.current
        let components = DateComponents(hour: Int(alarm.hours.wrappedValue), minute: Int(alarm.minutes.wrappedValue))
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

                    Toggle(isOn: $snooze, label: {
                        Text("Snooze")
                    })

                    if alarm != nil {
                        Section {
                            Button(action: {
                                self.moc.delete(alarm!)
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
        if self.alarm == nil {
            alarm = Alarm(context: self.moc)
            alarm.id = UUID().uuidString
            var idArray: [String] {
                var set: [String] = []
                for _ in 0...6 {
                    let id = UUID().uuidString
                    set.append(id)
                }
                return set
            }
            alarm.notificationIDs = idArray
        } else {
            alarm = self.alarm!
        }
        alarm.daysOfWeek = daysOfWeek
        alarm.active = true
        alarm.name = name
        alarm.snooze = snooze
        let actualTime = Calendar.current.dateComponents([.hour, .minute], from: time)
        alarm.hours = Int64(actualTime.hour!)
        alarm.minutes = Int64(actualTime.minute!)
        try? self.moc.save()
        LocalNotificationManager().removeNotifications(alarm.notificationIDs!)
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

}
