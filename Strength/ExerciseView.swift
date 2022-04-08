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
    @State var showListItems = false
    @State var animationDelay = 0.5
    init(exercise: Exercise) {
        self.exercise = exercise
        _exerciseSets = FetchRequest(
            entity: ExerciseSet.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseSet.order, ascending: true)], predicate: NSPredicate(format: "exercise == %@",exercise))
    }
    
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("ListItem"))
                .cornerRadius(20)
                .shadow(color: Color("Shadow"), radius: 4, x: 0, y: 3)
            HStack {
                VStack {
                    HStack {
                        Text(exercise.exerciseDetails?.name ?? "")
                        Spacer()
                        Text(exercise.exerciseDetails?.bodyPart ?? "")
                        
                        if (editMode?.wrappedValue.isEditing == true) {
                            Spacer()
                            Image(systemName: "xmark.bin.fill")
                                .onTapGesture {
                                    withAnimation(.easeOut){
                                        deleteExercise()
                                    }
                                }
                        }
                    }.font(.headline)
                    Divider()
                    ForEach(exerciseSets) { exerciseSet in
                        ExerciseSetView(set:exerciseSet)
//                            .animation(Animation.easeOut(duration: 0.6).delay(0.5), value: showListItems)
//                        Divider()
                    }
                    
                    HStack{
                        Spacer()
                        Text("Add Set")
                        Image(systemName: "plus")
                        Spacer()
                    }
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.1)){
                            addSet()
                        }
                    }
                    
                }.padding()
                .onTapGesture{
                    self.hideKeyboard()
                }
            }
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

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

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
