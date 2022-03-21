//
//  NewWorkoutPage.swift
//  Strength
//
//  Created by James Pollington on 10/03/2022.
//

import SwiftUI
import CoreData

struct NewWorkoutPage: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Workout.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Workout.started, ascending: false)]) var workouts: FetchedResults<Workout>
    
    init(sortDescriptor: NSSortDescriptor) {
        let fetchRequest = NSFetchRequest<Workout>(entityName: Workout.entity().name ?? "Workout" )
        fetchRequest.sortDescriptors = [sortDescriptor]

        _workouts = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var body: some View {
        
        if workouts.count == 0 {
            Text("No Workout Started")
        } else {
            WorkoutView(workout: workouts[0])
        }
    }
}

struct NewWorkoutPage_Previews: PreviewProvider {
    static var previews: some View {
        NewWorkoutPage(sortDescriptor: NSSortDescriptor(keyPath: \Workout.started, ascending: false))
    }
}
