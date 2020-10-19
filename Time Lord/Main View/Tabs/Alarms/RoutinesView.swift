//
//  RoutinesView.swift
//  Time Lord
//
//  Created by Isaac Lyons on 10/19/20.
//

import SwiftUI

struct RoutinesView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Routine.entity(), sortDescriptors: []) var routines: FetchedResults<Routine>

    @State private var showEditRoutineView = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(routines, id: \.self) { routine in
                        GroupBox(label: Text("Routine")) {
                            VStack(alignment: .leading) {
                                Text("\(routine.name!)")
                                Text(routine.beforesString())
                                Text(routine.aftersString())
                            }
                        }.groupBoxStyle(DetailBoxStyle(destination: EditRoutineView(routine: Binding<Routine>.constant(routine))))
                    }
                }
                Button("Press me!") {
                    showEditRoutineView = true
                }.sheet(isPresented: $showEditRoutineView) {
                    EditRoutineView()
                        .environment(\.managedObjectContext, self.moc)
                }
            }
        }
    }
}
