//
//  Routine+CoreDataClass.swift
//  Time Lord
//
//  Created by Isaac Lyons on 10/18/20.
//
//

import Foundation
import CoreData

@objc(Routine)
public class Routine: NSManagedObject {

    func beforesString() -> String {
        var newthing: [String] = []
        for i in befores! {
            newthing.append("\(i)")
        }
        return newthing.joined(separator: ", ")
    }

    func aftersString() -> String {
        var newthing: [String] = []
        for i in afters! {
            newthing.append("\(i)")
        }
        return newthing.joined(separator: ", ")
    }

}
