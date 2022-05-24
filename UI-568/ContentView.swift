//
//  ContentView.swift
//  UI-568
//
//  Created by nyannyan0328 on 2022/05/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model : PomodoroViewModel
    var body: some View {
       Home()
            .environmentObject(model)
          
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
