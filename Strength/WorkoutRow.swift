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
                VStack(alignment: .leading, spacing: 7) {
                    Text(workout.name ?? "")
                    Text(date)
                }
            }
        }
//        .onAppear(perform: dateFromString)
    }
    
//    func dateFromString(){
//        let formatter = DateFormatter()
//        formatter.timeStyle = .medium
//        formatter.dateStyle = .long
//        if workout.isEmpty{
//            return
//        }
//        date = formatter.string(from: workout.started!)
//      
//        
//
//    }
}

struct WorkoutRow_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let pTemplate = Workout(context: moc)
        pTemplate.name = "Push"
        return WorkoutRow(workout: pTemplate)
    }
}
