//
//  UI_568App.swift
//  UI-568
//
//  Created by nyannyan0328 on 2022/05/24.
//

import SwiftUI

@main
struct UI_568App: App {
    @StateObject var model : PomodoroViewModel = .init()
    @Environment(\.scenePhase) var pahse
    
    @State var lastActiveTimeStop : Date = Date()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
        .onChange(of: pahse) { newValue in
            
            
            if model.isStarted{
                
                if newValue == .background{
                    
                    lastActiveTimeStop = Date()
                    
                }
                
                if newValue == .active{
                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStop)
                    
                    if model.totalSeconds - Int(currentTimeStampDiff) <= 0{
                        model.isStarted = false
                        model.totalSeconds = 0
                        
                        model.upDateTimer()
                        
                    }
                    
                    else{
                        
                        model.totalSeconds -= Int(currentTimeStampDiff)
                    }
                    
                }
            }
        }
    }
}
