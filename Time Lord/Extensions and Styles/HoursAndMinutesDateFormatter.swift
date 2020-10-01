//
//  TimeOnlyDateFormatter.swift
//  Time Lord
//
//  Created by Isaac Lyons on 10/1/20.
//

import Foundation
import SwiftUI

extension DateFormatter {
    static let hoursAndMinutes: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}
