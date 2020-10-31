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

    @Binding var befores: [Int]
    @Binding var afters: [Int]
    @State private var addNewBefore = false
    @State private var newBefore = ""
    @State private var addNewAfter = false
    @State private var newAfter = ""

    init(befores: Binding<[Int]>, afters: Binding<[Int]>) {
        _befores = befores
        _afters = afters
    }

    var body: some View {
        NavigationView {
            Form {

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
                                Text("\(before)")
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
                            Text("+\(after)")
                            Spacer()
                            Button(action: {
                                let index = afters.firstIndex(of: after)
                                afters.remove(at: index!)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(Color.red)
                            }
                        }
                    }

                }

            }.navigationTitle("Routine")
            .navigationBarHidden(true)
        }
    }

    fileprivate func appendBefore() {
        if Int64(newBefore) == nil { return } //so we can safely force unwrap later
        for i in befores {
            if abs(i) == Int(newBefore) { return }
        }

        befores.append(-Int(newBefore)!)
        befores.sort(by: { $0 < $1 } )
        addNewBefore = false
        newBefore = ""
    }

    fileprivate func appendAfter() {
        if Int64(newAfter) == nil { return } //so we can safely force unwrap later
        for i in afters {
            if abs(i) == Int(newAfter) { return }
        }

        afters.append(Int(newAfter)!)
        afters.sort(by: { $0 < $1 } )
        addNewAfter = false
        newAfter = ""
    }

}
