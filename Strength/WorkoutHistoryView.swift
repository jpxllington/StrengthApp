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
    
    @State var showAlert: Bool = false
    
    var body: some View {
        NavigationView{
            if workouts.count == 0 {
                Text("No workout history found")
                    .navigationTitle("Workout History")
            } else {
                VStack {
                    List{
                        ForEach(workouts) { workout in
                            
                            VStack {
                                Spacer(minLength: 15)
                                ZStack {
                                    Rectangle()
                                       .foregroundColor(Color("ListItem"))
                                       .cornerRadius(10)
                                       .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
                                       .padding(-7)
                                    WorkoutRow(workout:workout)
                                }
                                Spacer(minLength: 15)
                                
                            }
                            .listRowSeparator(.hidden)
                        }.onDelete(perform: deleteWorkout)
                        Button(action: {showAlert.toggle()}){
                            ZStack {
                                Rectangle()
                                   .foregroundColor(.red)
                                   .cornerRadius(10)
                                   .padding(-6)
                                HStack {
                                    Spacer()
                                    Text("Delete all workouts")
                                    Spacer()
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                    }.listStyle(.inset)
                        
                }
                .navigationTitle("Workout History")
                .alert("Are you sure you want to delete all workouts?", isPresented: $showAlert){
                    Button("Yes"){
                        deleteAllWorkouts()
                        showAlert.toggle()
                    }
                    Button("No"){
                        showAlert.toggle()
                    }
                }
                .background(Color.blue)
            }
                
        }
        
        
    }
    func deleteWorkout(at offsets: IndexSet){
        for index in offsets {
            let template = workouts[index]
            managedObjectContext.delete(template)
            if managedObjectContext.hasChanges{
                do{
                    try managedObjectContext.save()
                } catch {
                    print(error)
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
