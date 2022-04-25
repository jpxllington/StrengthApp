//
//  IntervalTimer.swift
//  Strength
//
//  Created by James Pollington on 20/04/2022.
//

import SwiftUI

struct IntervalTimer: View {
    @State var timeRemaining = 0
    @State var highTimeRemaining = 0
    @State var lowTimeRemaining = 0
    @State var highIntensity: String = ""
    @State var lowIntensity: String = ""
    @State var intervals:String = ""
    @State var highInt: Int = 0
    @State var lowInt: Int = 0
    @State var repititions: Int = 0
    @State var started: Bool = false
    @State var warmUp: Bool = true
    @State var high: Bool = true
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let highTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let lowTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let screenSize = UIScreen.main.bounds
       var body: some View {
           NavigationView{
               if(!started) {
                   VStack(){
                       Spacer()
                       HStack {
                           Spacer()
                           VStack{
                               Section(header: Text("High Intensity")) {
                                   TextField("Enter duration", text: $highIntensity)
                                       .keyboardType(.decimalPad)
                                       .background(Color("TextFieldBackground"))
                                       .cornerRadius(5)
                                       .multilineTextAlignment(.center)
                                       .shadow(color: Color("TextFieldBackground"), radius: 0, x: 0, y: 0)
                               }
                               
                               Section(header: Text("Low Intensity")) {
                                   TextField("Enter duration", text: $lowIntensity )
                                       .keyboardType(.decimalPad)
                                       .background(Color("TextFieldBackground"))
                                       .cornerRadius(5)
                                       .multilineTextAlignment(.center)
                                       .shadow(color: Color("TextFieldBackground"), radius: 0, x: 0, y: 0)
                               }
                               Section(header: Text("Intervals")) {
                                   TextField("Number of intervals", text: $intervals )
                                       .keyboardType(.decimalPad)
                                       .background(Color("TextFieldBackground"))
                                       .cornerRadius(5)
                                       .multilineTextAlignment(.center)
                                       .shadow(color: Color("TextFieldBackground"), radius: 0, x: 0, y: 0)
                                       .frame(width: 200)
                               }
                           }
                           .frame(width: screenSize.width * 0.8)
                           Spacer()
                       }
                       Spacer()
                       
                       Button(action: {cleanInput()}){
                           ZStack {
                               Rectangle()
                                  .foregroundColor(Color("SavedSet"))
                                  .cornerRadius(20)
                                  .frame(width: screenSize.width * 0.8, height: screenSize.height * 0.3 )
                                  .overlay(
                                       RoundedRectangle(cornerRadius: 20)
                                       .stroke(Color("Shadow"), lineWidth: 2)
                                       
                                       )
                               HStack {
                                   Spacer()
                                   Text("Start Timer")
                                   Spacer()
                               }
                           }
                       }
                   }
                   .navigationBarTitle("New Interval Timer")
               } else {
                   if(warmUp) {
                       ZStack {
                           Circle()
                               .stroke(lineWidth: 20.0)
                               .opacity(0.3)
                               .foregroundColor(Color.yellow)
                           
                           Circle()
                               .trim(from: 0.0, to: CGFloat(min(Double(self.timeRemaining) / 10, 1.0)))
                               .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                               .foregroundColor(Color.yellow)
                               .rotationEffect(Angle(degrees: 270.0))
                               .animation(.easeInOut(duration: 0.8	), value: timeRemaining)
                           VStack {
                               Text("Time remaining:")
                               Spacer()
                               Text("\(timeRemaining)")
                                   .onReceive(timer) { _ in
                                       if (timeRemaining == 0){
                                           highTimeRemaining = highInt
                                           lowTimeRemaining = lowInt
                                           warmUp = false
                                           timeRemaining = -1
                                       }else if timeRemaining > 0 {
                                           timeRemaining -= 1
                                       }
                               }
                           }
                       }
                   }else if(high) {
                       ZStack {
                           Circle()
                               .stroke(lineWidth: 20.0)
                               .opacity(0.3)
                               .foregroundColor(Color.red)
                           
                           Circle()
                               .trim(from: 0.0, to: CGFloat(min(Double(self.highTimeRemaining) / Double(highInt), 1.0)))
                               .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                               .foregroundColor(Color.red)
                               .rotationEffect(Angle(degrees: 270.0))
                               .animation(.easeInOut(duration: 0.8    ), value: highTimeRemaining)
                           VStack {
                               Text("Time remaining:")
                               Spacer()
                               Text("\(highTimeRemaining)")
                                   .onReceive(highTimer) { _ in
                                       if highTimeRemaining == 0{
                                           timeRemaining = 10
                                           warmUp = true
                                           high = false
                                           highTimeRemaining = -1
                                       }else if highTimeRemaining > 0 {
                                           highTimeRemaining -= 1
                                           print(highTimeRemaining)
                                       }
                               }
                           }
                       }
                   }else {
                       ZStack {
                           Circle()
                               .stroke(lineWidth: 20.0)
                               .opacity(0.3)
                               .foregroundColor(Color.green)
                           
                           Circle()
                               .trim(from: 0.0, to: CGFloat(min(Double(self.lowTimeRemaining) / Double(lowInt), 1.0)))
                               .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                               .foregroundColor(Color.green)
                               .rotationEffect(Angle(degrees: 270.0))
                               .animation(.easeInOut(duration: 0.8    ), value: lowTimeRemaining)
                           VStack {
                               Text("Time remaining:")
                               Spacer()
                               Text("\(lowTimeRemaining)")
                                   .onReceive(lowTimer) { _ in
                                       if lowTimeRemaining == 0{
                                           repititions -= 1
                                           
                                           if repititions == 0{
                                               stopTimer()
                                           } else {
                                               timeRemaining = 10
                                               warmUp = true
                                               high = true
                                           }
                                           lowTimeRemaining = -1
                                       }else if lowTimeRemaining > 0 {
                                           lowTimeRemaining -= 1
                                       }
                               }
                           }
                       }
                   }
                   
               }
           }
       }
    
    func cleanInput(){
        highIntensity = highIntensity.trimmingCharacters(in: .whitespacesAndNewlines)
        lowIntensity = lowIntensity.trimmingCharacters(in: .whitespacesAndNewlines)
        intervals = intervals.trimmingCharacters(in: .whitespacesAndNewlines)
        
        highInt = Int(highIntensity) ?? 0
        lowInt = Int(lowIntensity) ?? 0
        repititions = Int(intervals) ?? 0
        
        startTimer()
    }
    
    func startTimer(){
        timeRemaining = 10
        highTimeRemaining = highInt
        lowTimeRemaining = lowInt
        started = true
        
    }
    
    func switchIntensisty(){
        
    }
    
    func pauseTimer(){
        
    }
    
    func stopTimer(){
        
    }
    func cancelTimer(){
        
    }
}

struct IntervalTimer_Previews: PreviewProvider {
    static var previews: some View {
        IntervalTimer()
    }
}
