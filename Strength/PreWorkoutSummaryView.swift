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
    @Binding var navActive: Bool
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                if template.exercises?.count == 0 {
                    Text("No Exercises Added")
                        .fontWeight(.semibold)
                    Text("Start workout to add exercises")
                        .fontWeight(.light)
                }
                ForEach(Array(template.exercises as? Set<TemplateExercise> ?? [] ), id: \.self) { exercise in
                    HStack {
                        Spacer()
                        Text(String(exercise.templateExerciseSet!.count) + "x:" )
                        Text(exercise.exerciseDetails!.name ?? "")
                        Spacer()
                        Text(exercise.exerciseDetails!.bodyPart ?? "")
                        Spacer()
                    }
                    Spacer()
                }
                
            }
            .navigationBarTitle("Workout Overview")
            .navigationBarItems(leading: Button(action:{
                self.showSummary = false
                self.navActive.toggle()
            }){Text("Cancel")}, trailing:
                Button(action: {
                newWorkout()
                self.showSummary = false
                
            }) {Text("Start")} )
        }
//        .onAppear(perform: newWorkout)
    
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
