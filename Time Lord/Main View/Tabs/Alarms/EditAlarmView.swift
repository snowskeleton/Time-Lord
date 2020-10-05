//  EditAlarmView.swift
//  Time Lord
//
//  Created by Isaac Lyons on 9/30/20.
//

import SwiftUI

struct EditAlarmView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Alarm.entity(), sortDescriptors: []) var alarms: FetchedResults<Alarm>

    @State private var new = true
    @Binding var alarm: Alarm
    @State private var time = Date()
    @State private var name = ""
    @State private var snooze = false
    @State private var showDaysPicker = false
    @State private var saveMe = false
    @Binding var daysOfWeek: [Bool]

    init(alarm: Binding<Alarm>) {
        self._alarm = alarm
        self._daysOfWeek = Binding<[Bool]>(alarm.daysOfWeek)!
    }
    
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

                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    .padding()
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                Form {
                    NavigationLink(destination: DayOfTheWeekPicker(activeDays: Binding<[Bool]>.constant(alarm.daysOfWeek ?? [false, false, false, false, false, false, false]))) {
                        HStack {
                            Text("Repeat")
                        }
                    }
                    TextField("Name", text: $name)
                    Toggle(isOn: $snooze, label: {
                        Text("Snooze")
                    })
                }
                Spacer()
            }
            .navigationBarHidden(true)
        }
        .onDisappear() {
            if saveMe == false {
                self.moc.delete(alarm)
            }
        }
    }
    fileprivate func save() {
        saveMe = true
        alarm.id = UUID().uuidString
        alarm.daysOfWeek = daysOfWeek
        alarm.active = true
        alarm.name = name
        alarm.snooze = snooze
        alarm.timeOfDay = time
        alarm.daysOfWeekString = boolToString(alarm.daysOfWeek!)
        try? self.moc.save()
    }

    fileprivate func boolToString(_ days: [Bool]) -> String {
        if days[0] == true && days[6] == true {
            return "Weekends"
        }
        var weekdays = true
        for i in 1...5 {
            if days[i] == false {
                weekdays = false
            }
        }
        if weekdays == true { return "Weekdays" }
        var daysOfWeek: [String] = []
        if days[0] == true { daysOfWeek.append("Sunday") }
        if days[1] == true { daysOfWeek.append("Monday") }
        if days[2] == true { daysOfWeek.append("Tuesday") }
        if days[3] == true { daysOfWeek.append("Wednesday") }
        if days[4] == true { daysOfWeek.append("Thursday") }
        if days[5] == true { daysOfWeek.append("Friday") }
        if days[6] == true { daysOfWeek.append("Saturday") }
        return daysOfWeek.joined(separator: ", ")
    }
}
