//
//  DayOfTheWeekPicker.swift
//  Time Lord
//
//  Created by Isaac Lyons on 10/1/20.
//

import SwiftUI

struct DayOfTheWeekPicker: View {
    //    @Binding var alarm: Alarm
    @State private var activeDays = [false, false, false, false, false, false, false]
    @State private var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    //    @State private var
    var body: some View {
        List {
            ForEach(days, id: \.self) { day in
                Button(action: {
                    activeDays[days.firstIndex(of: day)!].toggle()
                }) {
                    HStack {
                        Text("\(day)")
                        if activeDays[days.firstIndex(of: day)!] == true {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            Button(action: {
                for i in 1...5 {
                    activeDays[i] = true
                    //eventually I'll need to make this toggle based on some criteria
                }
            }) {
                Text("Weekdays")
            }
            Button(action: {
                activeDays[0] = true
                activeDays[6] = true
                //same here
            }) {
                Text("Weekends")
            }
        }
    }
}

