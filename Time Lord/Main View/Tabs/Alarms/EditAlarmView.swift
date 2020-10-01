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
    @State var alarm: Alarm?
    @State private var time = Date()
    @State private var name = ""
    @State private var snooze = false
    @State private var showDaysPicker = false
    @State private var saveMe = false
    @State var daysOfWeek = [false, false, false, false, false, false, false]
    
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
                    NavigationLink(destination: DayOfTheWeekPicker()) {
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
        }.onAppear {
            if alarm == nil {
                alarm = Alarm(context: self.moc)
            } else {
                new = false
            }
        }
        .onDisappear() {
            if saveMe == false {
                self.moc.delete(alarm!)
            }
        }
    }
    fileprivate func save() {
        saveMe = true
        if new {
            alarm?.daysOfWeek = daysOfWeek
            alarm?.active = true
            alarm!.name = name
            alarm!.snooze = snooze
            alarm?.timeOfDay = time
            try? self.moc.save()
        }
    }
}
