//
//  Home.swift
//  UI-568
//
//  Created by nyannyan0328 on 2022/05/24.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var model : PomodoroViewModel
    var body: some View {
        VStack{
            
            Text("Pomodoro Timer")
                .font(.largeTitle.weight(.black))
            
            
            GeometryReader{proxy in
                
                
                VStack{
                    ZStack{
                        
                        Circle()
                            .fill(.white.opacity(0.03))
                            .padding(-40)
                        
                        Circle()
                           .trim(from: 0, to: model.progress)
                           .stroke(.white.opacity(0.03),lineWidth: 80)
                        
                        
                        
                        Circle()
                            .stroke(Color("Purple"),lineWidth: 5)
                            .blur(radius: 15)
                            .padding(2)
                        
                        
    
                        Circle()
                            .fill(Color("BG"))
                        
                        
                        Circle()
                            .trim(from: 0, to: model.progress)
                            .stroke(Color("Purple"),lineWidth: 13)
                        
                        
                        GeometryReader{proxy in
                            
                            let size = proxy.size
                            
                            Circle()
                                .fill(Color("Purple"))
                                .frame(width: 30, height: 30)
                                .overlay(content: {
                                    
                                    Circle()
                                        .fill(.white)
                                        .padding(5)
                                    
                                })
                                .frame(width: size.width, height: size.height)
                                .offset(x: size.height / 2)
                                .rotationEffect(.init(degrees: model.progress * 360))
                        }
                        
                        Text(model.timerString)
                            .font(.system(size: 50, weight: .black))
                            .rotationEffect(.init(degrees: 90))
                            .animation(.none, value: model.progress)
                       
                    }
                    .padding(60)
                    .frame(height: proxy.size.width)
                    .rotationEffect(.init(degrees: -90))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                   
                    
                    
                    Button {
                        
                        if model.isStarted{
                            model.stopTimer()
                            
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        }
                        
                        else{
                            
                            model.addNewTimer = true
                        }
                        
                    } label: {
                        
                        Image(systemName: "timer")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background{
                             Circle()
                                    .fill(Color("Purple"))
                            }
                            .shadow(color: Color("Purple"), radius: 5, x: 0, y: 0)
                    }

                    
                        
                }
              
                
                
            }
            
        }
        .preferredColorScheme(.dark)
        .background{
            Color("BG").ignoresSafeArea()
        }
        .overlay {
            
            ZStack{
                
                Color.black
                    .opacity(model.addNewTimer ? 0.25 : 0)
                    .onTapGesture {
                        
                        model.minutes = 0
                        model.hour = 0
                        model.seconds = 0
                        model.addNewTimer = false
                    }
                
                
                NewTimerView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .bottom)
                 .offset(y: model.addNewTimer ? 0 : 400)
                
            }
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            
            
            if model.isStarted{
                
                model.upDateTimer()
            }
        }
        .alert("Congratulations You did it horray🫣🫣🫣🫣🫣", isPresented: $model.isFinished) {
            
            
            Button("Start New",role: .cancel){
                
                model.stopTimer()
                model.addNewTimer = true
                
            }
            
            Button("Stop",role: .destructive){
                
                model.stopTimer()
                
            }
        }
        
    }
    @ViewBuilder
    func NewTimerView()->some View{
        VStack{
            
            Text("Add New Timer View")
                .font(.title2.weight(.bold))
                .foregroundColor(.white)
                .padding(.top,20)
            
            
            HStack(spacing:15){
                
                
                Text("\(model.hour)hr")
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.vertical,15)
                    .padding(.horizontal,15)
                    .background{
                     
                        
                        Circle()
                            .fill(.white.opacity(0.7))
                    }
                    .contextMenu{
                        
                        
                        CustomContextMenu(maxValue: 12, hint: "hr") { value in
                            
                            model.hour = value
                        }
                    }
                
                
                Text("\(model.minutes)min")
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.vertical,15)
                    .padding(.horizontal,15)
                    .background{
                     
                        
                        Circle()
                            .fill(.white.opacity(0.7))
                    }
                    .contextMenu{
                        CustomContextMenu(maxValue: 60, hint: "min") { value in
                            
                            model.minutes = value
                        }
                        
                        
                    }
                
                
                
                Text("\(model.seconds)sc")
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.vertical,15)
                    .padding(.horizontal,15)
                    .background{
                     
                        
                        Circle()
                            .fill(.white.opacity(0.7))
                    }
                    .contextMenu{
                        CustomContextMenu(maxValue: 60, hint: "sc") { value in
                            
                            model.seconds = value
                        }
                        
                    }
                
                
            }
            
            
            Button {
                model.startTimer()
            } label: {
                
                
                Text("SAVE")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .padding(.vertical,15)
                    .padding(.horizontal,100)
                    .background{
                    Capsule()
                            .fill( Color("Purple"))
                        
                    }
                
                
            }
            .padding(.top,15)
            .disabled(model.seconds == 0)
            .opacity(model.seconds == 0 ? 0.5 : 1)

            
            
        }
        .frame(maxWidth: .infinity)
        .background{
         
            Color("BG")
                .ignoresSafeArea()
        }
        

        
    }
    @ViewBuilder
    func CustomContextMenu(maxValue : Int,hint : String,onClick : @escaping(Int) -> ())->some View{
        
        
        ForEach(0...maxValue,id:\.self){value in
            
            
            Button("\(value)\(hint)"){
                
                onClick(value)
            }
            
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PomodoroViewModel())
    }
}
