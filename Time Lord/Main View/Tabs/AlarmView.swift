//
//  AlarmView.swift
//  Time Lord
//
//  Created by Isaac Lyons on 9/30/20.
//

import SwiftUI

struct AlarmView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Alarm.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "hours", ascending: true),
                                    NSSortDescriptor(key: "minutes", ascending: true)]) var alarms: FetchedResults<Alarm>
    @State private var showAddAlarm = false
    @State private var edit = false
    @State private var showEditAlarm = false
    @State private var selectedAlarm = 0

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
                            .environment(\.managedObjectContext, self.moc)
                    }
                }

                List {
                    ForEach(alarms, id: \.self) { alarm in
                        Button(action: {
                            selectedAlarm = Int(alarms.firstIndex(of: alarm)!)
                            showEditAlarm = true
                        }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(alarm.hours):\(alarm.minutes)")
                                    .font(.largeTitle)
                                Text("\(alarm.weekDaysAsString())")
                            }
                        }
                        .sheet(isPresented: $showEditAlarm) {
                            EditAlarmView(alarm: Binding<Alarm>.constant(alarms[selectedAlarm]))
                                .environment(\.managedObjectContext, self.moc)
                        }
                        }
                    }
                    .onDelete(perform: deleteAlarm)
                }
                .navigationBarHidden(true)
            }
        }
    }

    fileprivate func deleteAlarm(at offsets: IndexSet) {
        for index in offsets {
            let alarm = alarms[index]
            moc.delete(alarm)
            try? self.moc.save()
        }
    }

}

struct AlarmView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmView()
    }
}
