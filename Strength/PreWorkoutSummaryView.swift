//
//  PreWorkoutSummaryView.swift
//  Strength
//
//  Created by James Pollington on 09/03/2022.
//

import SwiftUI
import CoreData

struct PreWorkoutSummaryView: View {
    @ObservedObject var template: Template
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var showSummary: Bool
    @State var navActive: Bool = false

    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .center) {
                if template.exercises?.count == 0 {
                    Spacer()
                    Text("No Exercises Added")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("Start workout to add exercises")
                        .fontWeight(.light)
                    Spacer()
                }
                ZStack {
                    
                    
                    List {
                        ForEach(Array(template.exercises as? Set<TemplateExercise> ?? [] ), id: \.self) { exercise in
//                            HStack {
//                                Text(String(exercise.templateExerciseSet!.count) + "x:" )
//                                Text(exercise.exerciseDetails!.name ?? "")
//
//
//                            }
                            TemplateExerciseView(exercise: exercise).padding(.horizontal, 10)
                        }
                        .listRowSeparator(.hidden)
                    }.listStyle(.inset)
//                    .background(Color("ListItem"))
//                        .cornerRadius(20)
//                        .shadow(color: Color("Shadow").opacity(0.1), radius: 3, x: 0, y: 3)
//                        .padding(-25)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
            }
            .background(NavigationLink(destination: NewWorkoutPage(sortDescriptor: NSSortDescriptor(keyPath: \Workout.started, ascending: false)), isActive: $navActive ) {})
            .navigationBarTitle("Workout Overview")
            .navigationBarItems(leading: Button(action:{
                self.showSummary = false
                
            }){Text("Cancel")}, trailing:
                Button(action: {
                activateWorkout()
            }) {Text("Start")} )
            
        }
        .onAppear(perform: {navActive = false})
       
    }
    func activateWorkout(){
        newWorkout()
//        self.showSummary = false
        self.navActive = true
    }
    
    func newWorkout() {
        let workout = Workout(context: managedObjectContext)
        workout.name = template.name
        workout.started = Date()
        for exercise in template.exercises! {
            let newExercise = Exercise(context: managedObjectContext)
            newExercise.exerciseDetails = (exercise as AnyObject).exerciseDetails
            newExercise.displayOrder = (exercise as AnyObject).displayOrder
            if (exercise as AnyObject).templateExerciseSet!.count > 0 {
                for exerciseSet in (exercise as AnyObject).templateExerciseSet! {
                    let newSet = ExerciseSet(context: managedObjectContext)
                    newSet.weight = (exerciseSet as AnyObject).weight
                    newSet.reps = (exerciseSet as AnyObject).reps
                    newSet.order = (exerciseSet as AnyObject).order
                    newExercise.addToExerciseSets(newSet)
                }
            }
            workout.addToExercises(newExercise)
        }
        workout.template = template
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
}

struct PreWorkoutSummaryView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
    let pTemplate = Template(context: moc)
    pTemplate.name = "Push"
    return TemplateRow(template: pTemplate)
    }
}
