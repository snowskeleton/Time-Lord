//
//  DayOfTheWeekPicker.swift
//  Time Lord
//
//  Created by Isaac Lyons on 10/1/20.
//

import SwiftUI

struct DayOfTheWeekPicker: View {
    @Binding var activeDays: [Bool]
    var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var allWeekDaysSelected: Bool {
        for i in 1...5 { if activeDays[i] == false { return false } }
        return true
    }
    var allWeekEndsSelected: Bool {
        if activeDays[0] && activeDays[6] { return true }
        return false
    }

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
                if allWeekDaysSelected {
                    for i in 1...5 {
                        activeDays[i] = false
                    }
                } else {
                    for i in 1...5 {
                        activeDays[i] = true
                    }
                }
            }) {
                Text("Weekdays")
            }
            Button(action: {
                if allWeekEndsSelected {
                    activeDays[0] = false
                    activeDays[6] = false
                } else {
                    activeDays[0] = true
                    activeDays[6] = true
                }
            }) {
                Text("Weekends")
            }
        }
    }
}

