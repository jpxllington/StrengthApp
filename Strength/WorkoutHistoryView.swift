//
//  WorkoutHistoryView.swift
//  Strength
//
//  Created by James Pollington on 09/03/2022.
//

import SwiftUI
import CoreData

struct WorkoutHistoryView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Workout.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Workout.started, ascending: false)]) var workouts: FetchedResults<Workout>
    
    init(sortDescriptor: NSSortDescriptor) {
        let fetchRequest = NSFetchRequest<Workout>(entityName: Workout.entity().name ?? "Workout" )
        fetchRequest.sortDescriptors = [sortDescriptor]

        _workouts = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var body: some View {
        NavigationView{
            if workouts.count == 0 {
                Text("No Templates Added")
            } else {
                VStack {
                    List{
                        ForEach(workouts) { workout in
                            WorkoutRow(workout:workout)
                        }
                        Button(action: {deleteAllWorkouts()}){
                            Text("Delete all workouts")
                        }
                    }
                    
                }
            }
        }
    }
    
    func deleteAllWorkouts(){
        for workout in workouts {
            managedObjectContext.delete(workout)
        }
        do{
            try managedObjectContext.save()
        } catch {
            print(error)
        }
    }
}

struct WorkoutHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHistoryView(sortDescriptor: NSSortDescriptor(keyPath: \Workout.started, ascending: false))
    }
}
