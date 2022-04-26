//
//  ExerciseStatsView.swift
//  Strength
//
//  Created by James Pollington on 22/03/2022.
//

import SwiftUI
import CoreData
import SwiftUICharts

struct ExerciseStatsView: View {
    @ObservedObject var exerciseDetails: ExerciseDetails
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var totalVolume: [Double] = []
    @State var maxWeight: [Double] = []
    @State var totalVolumeString: [String] = []
    @State var maxWeightString: [String] = []
    @State var maxVolume: String = ""
    @State var exerciseDate: [Date] = []
    @State var exerciseDateString: [String] = []
    @State var heaviestSet: Double = 0
    @State var heaviestSetString: String = "10"
    @State var chartType: Bool = true
    @State var timesExercised: Int = 0
    @State var timesExercisedString: String = "0"
    @State var mostRecentExercise: String = ""
    @State var maxWeightGraph: [Double] = []
    @State var totalVolumeGraph: [Double] = []
    @State var exerciseList: [Exercise] = []
    @State var exerciseToShow: [Exercise] = []
    @State var showLastExercise: Bool = true
    
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0){
                if timesExercised > 1 {
                    if chartType {
                        VStack{
                            LineChartView(data: totalVolume, title: "Total Volume", form: ChartForm.extraLarge, rateValue: 0, dropShadow: false)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color("Shadow").opacity(0.3), lineWidth: 2)
                                    
                                    )
                            LineChartView(data: maxWeight, title: "Max Weight", form: ChartForm.extraLarge, rateValue: 0, dropShadow: false).overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color("Shadow").opacity(0.3), lineWidth: 2)
                                
                                )
                        }
                        .shadow(color: Color("Shadow").opacity(0.15), radius: 3, x: 0, y: 3)
                    } else {
                        VStack{
                            BarChartView(data: ChartData(points: totalVolumeGraph), title: "Total Volume", form: ChartForm.extraLarge, dropShadow: false)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color("Shadow").opacity(0.3), lineWidth: 2)
                                    
                                    )
                            BarChartView(data: ChartData(points: maxWeightGraph), title: "Max Weight", form: ChartForm.extraLarge, dropShadow: false)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color("Shadow").opacity(0.3), lineWidth: 2)
                                    
                                    )
                        }
                        .shadow(color: Color("Shadow").opacity(0.15), radius: 3, x: 0, y: 3)
                    }
                    Spacer()
                    Divider()
                    Spacer()
                }
                
                HStack(spacing: 0){
                    ExerciseStatHolder(titleText: "Heaviest set", dataText: $heaviestSetString)
                    ExerciseStatHolder(titleText: "Number of sets completed", dataText: $timesExercisedString)
                }.transition(.scale)
                    
                    
                HStack(spacing: 0){
                    ExerciseStatHolder(titleText: "Greatest Volume", dataText: $maxVolume)
                    ExerciseStatHolder(titleText: "Most recent set", dataText: $mostRecentExercise)
                }
                    
                Spacer()
                Divider()
                Spacer()
                Text("Most Recent Exercise")
                    .fontWeight(.semibold)
                Spacer()
                ForEach(exerciseToShow){exercise in
                    LastExerciseView(exercise: exercise)
                        .padding()
                }
                Spacer(minLength: 120)
            }
            .onAppear(perform: {
                withAnimation(){
                    
                }
            createArrays()})
            .navigationTitle(exerciseDetails.name ?? "")
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    if timesExercised > 1 {
                        Button(action: {chartType.toggle()}, label: {Image(systemName: chartType ? "chart.bar" : "chart.xyaxis.line")})
                    }
                }
            }
        }
    }
    
    
    
    func createArrays(){
        totalVolume = []
        maxWeight = []
        exerciseDate = []
        timesExercised = 0
        totalVolumeString = []
        maxWeightString = []
        maxWeightGraph = []
        totalVolumeGraph = []
        exerciseList = []
        exerciseToShow = []
        
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        
        for exercise in exerciseDetails.exercises! {
            var exerciseVolume: Double = 0
            var exerciseMaxWeight: Double = 0
            timesExercised += 1
            // sort me by date please 
            for exerciseSet in (exercise as AnyObject).exerciseSets! {
                exerciseVolume += Double((exerciseSet as AnyObject).weight * Double((exerciseSet as AnyObject).reps))
                
                if (exerciseSet as AnyObject).weight > exerciseMaxWeight{
                    exerciseMaxWeight = (exerciseSet as AnyObject).weight
                }
            }
            
                totalVolume.append(exerciseVolume)
                maxWeight.append(exerciseMaxWeight)
            
            if exerciseMaxWeight > self.heaviestSet {
                heaviestSet = exerciseMaxWeight
            }
            let workout = (exercise as AnyObject).workout!
            exerciseDate.append(workout!.started!)
            exerciseDateString.append(formatter.string(from: workout!.started!))
            exerciseList.append(exercise as! Exercise)
        }
        
        print(exerciseDate.count)
        print(totalVolume.count)
        print(maxWeight.count)
        let offsets = exerciseDate.enumerated().sorted { $0.element > $1.element }.map { $0.offset }
        totalVolume = offsets.map {totalVolume[$0]}
        maxWeight = offsets.map {maxWeight[$0]}
        exerciseList = offsets.map {exerciseList[$0]}
        
        var exerciseFound: Bool = false
        var index: Int = 0
        while !exerciseFound {
            if exerciseList[index].workout?.finished != nil {
                exerciseToShow.append(exerciseList[index])
                exerciseFound = true
            }
            index += 1
        }
        
        if exerciseDate.count < 10 {
            totalVolumeGraph = totalVolume
            maxWeightGraph = maxWeight
        } else {
            for index in 0...9 {
                totalVolumeGraph.append(totalVolume[index])
                maxWeightGraph.append(maxWeight[index])
            }
        }
        
        totalVolumeString = totalVolume.map { String($0) }
        maxVolume  = String(totalVolume.max()!)
        heaviestSetString = String(heaviestSet)
        mostRecentExercise = formatter.string(from: exerciseDate.max()!)
        timesExercisedString = String(timesExercised)
//        print(heaviestSetString)
//               print(totalVolumeString)
//               print(timesExercised)
//               print(exerciseDate.max()!)

    }
}

struct ExerciseStatsView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let pExerciseDetails = ExerciseDetails(context: moc)
        ExerciseStatsView(exerciseDetails: pExerciseDetails)
    }
}
