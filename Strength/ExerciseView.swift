//
//  ExerciseView.swift
//  Strength
//
//  Created by James Pollington on 09/03/2022.
//

import SwiftUI
import CoreData


struct ExerciseView: View {
    @ObservedObject var exercise: Exercise
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.editMode) private var editMode
    @FetchRequest var exerciseSets: FetchedResults<ExerciseSet>
    
    init(exercise: Exercise) {
        self.exercise = exercise
        _exerciseSets = FetchRequest(
            entity: ExerciseSet.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseSet.order, ascending: true)], predicate: NSPredicate(format: "exercise == %@",exercise))
    }
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(exercise.exerciseDetails?.name ?? "")
                    Spacer()
                    Text(exercise.exerciseDetails?.bodyPart ?? "")
                    Spacer()
                    if (editMode?.wrappedValue.isEditing == true) {
                        Image(systemName: "xmark.bin.fill")
                            .onTapGesture {
                                deleteExercise()
                            }
                    }
                }.font(.headline)
                Divider()
                ForEach(exerciseSets) { exerciseSet in

                    ExerciseSetView(set:exerciseSet)
                            .frame(height:50)
                        Divider()
                }
                
                HStack{
                    Text("Add Set")
                    Image(systemName: "plus")
                }.onTapGesture {
                    addSet()
            }
                    
        }.padding()
    }
    }
    
    func deleteExercise(){
        managedObjectContext.delete(exercise)
        if managedObjectContext.hasChanges{
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    func addSet(){
        let newSet = ExerciseSet(context: managedObjectContext)
        newSet.reps = 0
        newSet.weight = 0
        newSet.order = Int64((exercise.exerciseSets?.count ?? 0) + 1)
        exercise.addToExerciseSets(newSet)
        if managedObjectContext.hasChanges{
            do{
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
    let pExercise = Exercise(context: moc)
    pExercise.name = "Bench Press"
    pExercise.bodyPart = "Chest"
    let pSetOne = ExerciseSet(context: moc)
        pSetOne.reps = 10
        pSetOne.weight = 70
        pSetOne.order = 1
    let pSetTwo = ExerciseSet(context: moc)
        pSetTwo.reps = 8
        pSetTwo.weight = 80
        pSetTwo.order = 2
        let pSetThree = ExerciseSet(context: moc)
            pSetThree.reps = 8
            pSetThree.weight = 80
            pSetThree.order = 3
        pExercise.addToExerciseSets(pSetOne)
        pExercise.addToExerciseSets(pSetTwo)
        pExercise.addToExerciseSets(pSetThree)
    return ExerciseView(exercise: pExercise)    }
}
