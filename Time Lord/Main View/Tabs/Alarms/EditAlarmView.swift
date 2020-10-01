//  EditAlarmView.swift
//  Time Lord
//
//  Created by Isaac Lyons on 9/30/20.
//

import SwiftUI

struct EditAlarmView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    //    @Binding var new: Bool
    @State private var time = Date()
    @State private var name = ""
    @State private var snooze = false
    @State private var showDaysPicker = false
    
    var body: some View {
        NavigationView {
        VStack {
            
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }.padding()
                Spacer()
                Button("Save") {
                    // some other stuff
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
    }
}
}