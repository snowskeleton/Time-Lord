//
//  AlarmView.swift
//  Time Lord
//
//  Created by Isaac Lyons on 9/30/20.
//

import SwiftUI

struct AlarmView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Alarm.entity(), sortDescriptors: []) var alarms: FetchedResults<Alarm>
    @State private var showAddAlarm = false
    @State private var edit = false
    
    var body: some View {
        NavigationView {
        VStack {
            HStack {
                Button(action: {
                    edit = true
                }) {
                    Text("Edit")
                        .padding(.leading)
                }
                Spacer()
                Button(action: {
                    showAddAlarm = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .padding(.trailing)
                }
                .sheet(isPresented: $showAddAlarm) {
                    EditAlarmView()
                }
            }
            
            ScrollView {
                ForEach(alarms, id: \.self) { alarm in
                    GroupBox(label: Text("\(alarm.name ?? "")")) {
                        VStack {
                            Text("Content")
                            Text("More text")
                        }
                    }
                    .groupBoxStyle(DetailBoxStyle(destination: EditAlarmView()))
                    Divider()
                }
            }
            .navigationBarHidden(true)
            
        }
        }
    }
}

struct AlarmView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmView()
    }
}