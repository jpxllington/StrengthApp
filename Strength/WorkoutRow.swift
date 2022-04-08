//
//  WorkoutRow.swift
//  Strength
//
//  Created by James Pollington on 09/03/2022.
//

import SwiftUI
import CoreData
struct WorkoutRow: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var workout: Workout
    @State var date = ""
    
    var body: some View {
        HStack(spacing: 0) {
            NavigationLink(destination: WorkoutView(workout:workout)) {
                ZStack {
//                    Rectangle()
//                        .foregroundColor(.white)
//                        .cornerRadius(20)
//                        .shadow(color: Color("Shadow"), radius: 4, x: 0, y: 3)
                    VStack(alignment: .leading, spacing: 7) {
                        HStack{
                            Text(workout.name ?? "")
                            Spacer()
                            if workout.finished != nil{
                                Text(calcDuration())
                                Spacer()
                            }
                            Text(date)
                        }
                        ForEach(Array(workout.exercises as? Set<Exercise> ?? [] ), id: \.self) { exercise in
                            HStack {
    //                                Spacer()
                                Text(String(exercise.exerciseSets!.count) + "x:" )
                                Text(exercise.exerciseDetails!.name ?? "")
                                
                            }
                         
                        }
                    }
                }
            }
        }
        .onAppear(perform: dateFromString)
    }
    
    func calcDuration() -> String{
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: workout.started!, to: workout.finished!)!
    }
    
    func dateFromString(){
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        date = formatter.string(from: workout.started!)
      
        

    }
}

struct WorkoutRow_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let pTemplate = Workout(context: moc)
        pTemplate.name = "Push"
        return WorkoutRow(workout: pTemplate)
    }
}
