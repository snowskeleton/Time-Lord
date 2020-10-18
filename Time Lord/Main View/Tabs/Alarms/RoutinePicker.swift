//
//  RoutinePickerr.swift
//  Time Lord
//
//  Created by Isaac Lyons on 10/18/20.
//

import SwiftUI

struct RoutinePicker: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Routine.entity(), sortDescriptors: []) var routines: FetchedResults<Routine>

    @Binding var selectedRoutines: [Routine]

    var body: some View {
        List {
            ForEach(routines, id: \.self) { routine in
                Button(action: {
                    selectedRoutines.append(routine)
                }) {
                    HStack {
                        Text("\(routine.name!)")
                        if selectedRoutines.contains(routine) {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
    }
}
