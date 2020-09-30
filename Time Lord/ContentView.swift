//
//  ContentView.swift
//  Time Lord
//
//  Created by Isaac Lyons on 9/30/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            
            AlarmView()
                .tag(1)
                .tabItem {
                    VStack {
                        Image(systemName: "alarm")
                        Text("Alarms")
                    }
                }
            
            TimerView()
                .tag(2)
                .tabItem {
                    VStack {
                        Image(systemName: "clock")
                        Text("Timers")
                    }
                }
            
           StopwatchView()
                .tag(3)
                .tabItem {
                    VStack {
                        Image(systemName: "stopwatch")
                        Text("Stopwatch")
                    }
                }
            
            SettingsView()
                .tag(4)
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
