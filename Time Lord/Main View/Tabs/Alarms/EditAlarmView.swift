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
    @State private var time = Date()
    @State private var name: String = ""
    @State private var snooze = false
    @State var daysOfWeek: [Bool] = [false, false, false, false, false, false, false]
    @State private var showDaysPicker = false

    init(alarm: Binding<Alarm>) {
        _alarm = State(initialValue: alarm.wrappedValue)
        _time = (alarm.timeOfDay.wrappedValue != nil
                    ? State<Date>(initialValue: alarm.timeOfDay.wrappedValue!)
                    : State<Date>(initialValue: (Date()))
        )
        _name = State(initialValue: alarm.name.wrappedValue ?? "")
        _snooze = State(initialValue: alarm.snooze.wrappedValue)
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

                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    .padding()
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

                }
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
    fileprivate func save() {
        var alarm: Alarm
        if self.alarm == nil {
            alarm = Alarm(context: self.moc)
            alarm.id = UUID().uuidString
        } else {
            alarm = self.alarm!
        }
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
