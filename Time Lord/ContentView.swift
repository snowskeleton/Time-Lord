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
            
            Text("Timers")
                .tag(2)
                .tabItem {
                    VStack {
                        Image(systemName: "clock")
                        Text("Timers")
                    }
                }
            
            Text("Stop Watch")
                .tag(3)
                .tabItem {
                    VStack {
                        Image(systemName: "stopwatch")
                        Text("Stopwatch")
                    }
                }
            Text("Settings")
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
