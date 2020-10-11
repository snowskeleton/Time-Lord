//
//  TimeEditPicker.swift
//  Time Lord
//
//  Created by Isaac Lyons on 10/11/20.
//

import SwiftUI

struct TimeEditPicker: View {
    @Binding var selectedHour: Int
    @Binding var selectedMinute: Int
    @State private var amOrPm = [0, 1]

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Spacer()
                Picker("", selection: self.$selectedHour) {
                    ForEach(0..<24) {
                        Text(String($0)).tag($0)
                    }
                }
                .labelsHidden()
                .fixedSize(horizontal: true, vertical: true)
                .frame(width: geometry.size.width / 5, height: 160)
                .clipped()

                Picker("", selection: self.$selectedMinute) {
                    ForEach(0..<60) {
                        Text(String($0)).tag($0)
                    }
                }
                .labelsHidden()
                .fixedSize(horizontal: true, vertical: true)
                .frame(width: geometry.size.width / 5, height: 160)
                .clipped()

                Picker("", selection: self.$amOrPm) {
                    Text("AM").tag(0)
                    Text("PM").tag(1)
                }
                .labelsHidden()
                .fixedSize(horizontal: true, vertical: true)
                .frame(width: geometry.size.width / 5, height: 160)
                .clipped()

                Spacer()
            }
        }
        .frame(height: 160)
        .mask(Rectangle())
    }
}
