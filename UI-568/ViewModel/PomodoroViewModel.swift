//
//  PomodoroViewModel.swift
//  UI-568
//
//  Created by nyannyan0328 on 2022/05/24.
//

import SwiftUI

class PomodoroViewModel:NSObject, ObservableObject,UNUserNotificationCenterDelegate {
    @Published var progress : CGFloat = 1
    
    @Published var timerString : String = "00:00"
    
    @Published var addNewTimer : Bool = false
    @Published var isStarted : Bool = false
    
    @Published var hour : Int = 0
    @Published var minutes : Int = 0
    @Published var seconds : Int = 0
    
    @Published var totalSeconds : Int = 0
    @Published var staticTotalSecond : Int = 0
    
    @Published var isFinished : Bool = false
    
    
    override init(){
        
        super.init()
        
        self.authorziedNotification()
    }
    
    func authorziedNotification(){
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.badge]) { _, _ in
            
            
        }
        
        
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.sound,.banner])
    }
    
   
    func startTimer(){
        
        
        withAnimation(.easeInOut){isStarted = true}
        
        timerString = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        
        totalSeconds = (hour * 3600) + (minutes * 60) + seconds
        
        staticTotalSecond = totalSeconds
        
        addNewTimer = false
        
        addNotification()
    }
    func upDateTimer(){
        
        if totalSeconds > 0{
            
            totalSeconds -= 1
        }
        
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSecond)
        progress = (progress < 0 ? 0 : progress)
        hour = totalSeconds / 3600
        minutes = (totalSeconds / 60) % 60
        seconds = (totalSeconds % 60)
        
        
        timerString = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        
        if hour == 0 && minutes == 0 && seconds == 0{
            
            
            
            isStarted = false
            isFinished = true
        }
        
        
        
        
    }
    
    func stopTimer(){
        
        withAnimation{
            
            isStarted = false
            hour = 0
            seconds = 0
            progress = 1
            minutes = 0
        }
        
        totalSeconds = 0
        staticTotalSecond = 0
        timerString = "00:00"
        
        
    }
    
    func addNotification(){
        
        let conent = UNMutableNotificationContent()
        conent.title = "Pomorodor Timer"
        conent.subtitle = "Congratulations You did it horray🫣🫣🫣🫣🫣"
        conent.sound = UNNotificationSound.default
        
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: conent, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSecond), repeats: false))
        
        UNUserNotificationCenter.current().add(request)
        
    }
   
}

