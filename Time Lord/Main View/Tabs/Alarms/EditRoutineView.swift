//
//  EditRoutineView.swift
//  Time Lord
//
//  Created by Isaac Lyons on 10/18/20.
//

import SwiftUI

struct EditRoutineView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc

    @State private var routine: Routine?
    @State private var befores: [Before] = []
    @State private var afters: [After] = []
    @State private var addNewBefore = false
    @State private var newBefore = ""
    @State private var addNewAfter = false
    @State private var newAfter = ""
    @State private var name = ""

    init(routine: Binding<Routine>) {
        _routine = State(initialValue: routine.wrappedValue)
        _befores = State(initialValue: routine.befores.wrappedValue!)
        _afters = State(initialValue: routine.afters.wrappedValue!)
    }
    init() {}

    var body: some View {
        NavigationView {
            Form {

                TextField("Name", text: $name)
                
                Section {

                    HStack {
                        TextField("Before", text: $newBefore)
                            .keyboardType(.numberPad)
                        Button("Add") {
                            appendBefore()
                        }.disabled((Int(newBefore) == nil))
                    }

                    List {
                        ForEach(befores, id: \.self) { before in
                            HStack {
                                Text(" -\(before.amount)")
                                Spacer()
                                Button(action: {
                                    let index = befores.firstIndex(of: before)
                                    befores.remove(at: index!)
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(Color.red)
                                }
                            }
                        }
                    }

                }

                Section {

                    HStack {
                        TextField("After", text: $newAfter)
                            .keyboardType(.numberPad)
                        Button("Add") {
                            appendAfter()
                        }.disabled((Int(newAfter) == nil))
                    }

                    ForEach(afters, id: \.self) { after in
                        HStack {
                            Text(" +\(after.amount)")
                            Spacer()
                            Button(action: {
                                let index = afters.firstIndex(of: after)
                                befores.remove(at: index!)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(Color.red)
                            }
                        }
                    }

                }

            }.navigationTitle("New Routine")
        }
    }

    private func appendBefore() {
        let new = Before(context: self.moc)
        new.amount = Int64(newBefore)!
        befores.append(new)
        befores.sort {
            $0.amount > $1.amount
        }
        addNewBefore = false
        newBefore = ""
    }

    private func appendAfter() {
        let new = After(context: self.moc)
        new.amount = Int64(newAfter)!
        afters.append(new)
        afters.sort {
            $0.amount > $1.amount
        }
        addNewAfter = false
        newAfter = ""
    }

}
