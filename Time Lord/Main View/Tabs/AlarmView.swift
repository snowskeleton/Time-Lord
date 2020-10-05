//
//  AlarmView.swift
//  Time Lord
//
//  Created by Isaac Lyons on 9/30/20.
//

import SwiftUI

struct AlarmView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Alarm.entity(), sortDescriptors: [NSSortDescriptor(key: "timeOfDay", ascending: true)]) var alarms: FetchedResults<Alarm>
    @State private var showAddAlarm = false
    @State private var edit = false
    @State private var newAlarm: Alarm?
    @State private var showEditAlarm = false

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
                        newAlarm = makeNewAlarm()
                        showAddAlarm = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .padding(.trailing)
                    }
                    .sheet(isPresented: $showAddAlarm) {
                        EditAlarmView(alarm: Binding<Alarm>.constant(newAlarm!))
                            .environment(\.managedObjectContext, self.moc)
                    }
                }

                List {
                    ForEach(alarms, id: \.self) { alarm in
                        Button(action: {
                            showEditAlarm = true
                        }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(alarm.timeOfDay ?? Date(), formatter: DateFormatter.hoursAndMinutes)")
                                    .font(.largeTitle)
                                Text("\(alarm.daysOfWeekString ?? "" )")
                            }
                        }
                        .sheet(isPresented: $showEditAlarm) {
                            EditAlarmView(alarm: Binding<Alarm>.constant(alarm))
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

    func makeNewAlarm() -> Alarm {
        newAlarm = Alarm(context: self.moc)
        newAlarm!.daysOfWeek = [false, false, false, false, false, false, false]
        try? self.moc.save()
        return newAlarm!
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
