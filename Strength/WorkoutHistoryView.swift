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
    @State var calendar: Bool = false
    
    
    var body: some View {
        NavigationView{
            if calendar {
                CalendarView(sortDescriptor: NSSortDescriptor(keyPath: \Workout.started, ascending: false))
                .navigationTitle("Workout History")
                .toolbar{
                    ToolbarItemGroup(placement: .navigationBarTrailing){
                        Button(action: {calendar.toggle()}, label: {Image(systemName: calendar ? "calendar.circle" : "calendar.circle.fill").foregroundColor(Color("TabIcon"))})
                        
                    }
                }
            } else {
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
                                           .cornerRadius(20)
                                           .shadow(color: Color("Shadow").opacity(0.1), radius: 3, x: 0, y: 3)
                                           .padding(-8)
//                                           .overlay(
//                                                RoundedRectangle(cornerRadius: 20)
//                                                .stroke(Color("Shadow"), lineWidth: 2)
//                                                .padding(-7)
//                                                )
                                        WorkoutRow(workout:workout)
                                    }
                                    Spacer(minLength: 15)
                                    
                                }
                                .listRowSeparator(.hidden)
                            }.onDelete(perform: deleteWorkout)
                            Button(action: {showAlert.toggle()}){
                                ZStack {
                                    Rectangle()
                                       .foregroundColor(Color("Failure"))
                                       .cornerRadius(20)
                                       .padding(-6)
                                    HStack {
                                        Spacer()
                                        Text("Delete all workouts")
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                }
                            }
                            Spacer(minLength: 120)
                            .listRowSeparator(.hidden)
                        }.listStyle(.inset)
                            .padding(.horizontal, 5)
                            
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
                    
                    .toolbar{
                        ToolbarItemGroup(placement: .navigationBarTrailing){
                            Button(action: {calendar.toggle()}, label: {Image(systemName: calendar ? "calendar.circle" : "calendar.circle.fill").foregroundColor(Color("TabIcon"))})
                            
                        }
                    }
                }
                    
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
