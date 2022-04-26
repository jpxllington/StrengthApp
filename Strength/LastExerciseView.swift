//
//  LastExerciseView.swift
//  Strength
//
//  Created by James Pollington on 08/04/2022.
//

import SwiftUI
import CoreData


struct LastExerciseView: View {

    @ObservedObject var exercise: Exercise
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest var exerciseSets: FetchedResults<ExerciseSet>
    init(exercise: Exercise) {
        self.exercise = exercise
        _exerciseSets = FetchRequest(
            entity: ExerciseSet.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseSet.order, ascending: true)], predicate: NSPredicate(format: "exercise == %@",exercise))
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("ListItem"))
                .cornerRadius(20)
                .shadow(color: Color("Shadow").opacity(0.25), radius: 4, x: 0, y: 3)
            HStack {
                VStack {
                    HStack {
                        Text(exercise.exerciseDetails?.name ?? "")
                        Spacer()
                        Text(exercise.exerciseDetails?.bodyPart ?? "")
                        
                    }.font(.headline)
                    Divider()
                    ForEach(exerciseSets) { exerciseSet in
                        HStack(alignment: .firstTextBaseline){
                            ZStack {
                                Rectangle()
                                    .cornerRadius(5)
                                    .foregroundColor(exerciseSet.failure ? exerciseSet.warmUp ? Color.orange : Color.red : exerciseSet.warmUp ? Color.yellow : Color("ListItem"))
                                    .frame(width: 20)
                                Text(String(exerciseSet.order))
                            }
                            
                            Section(header: Text("Weight:")){
                                Text(String(exerciseSet.weight) )
                                    .keyboardType(.decimalPad)
                                    .background(Color("TextFieldBackground"))
                                    .cornerRadius(5)
                                    .multilineTextAlignment(.center)
                                    .shadow(color: .gray, radius: 0, x: 0, y: 0)
                            }
                            Spacer()
                            Section(header: Text("Reps:")){
                                Text(String(exerciseSet.reps) )
                                    .keyboardType(.decimalPad)
                                    .background(Color("TextFieldBackground"))
                                    .cornerRadius(5)
                                    .multilineTextAlignment(.center)
                                    .shadow(color: Color("TextFieldBackground")    , radius: 0, x: 0, y: 0)
                            }
                        }
                    }
                }.padding()
                .onTapGesture{
                    self.hideKeyboard()
                }
            }
        }
    }
}

struct LastExerciseView_Previews: PreviewProvider {
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
    return LastExerciseView(exercise: pExercise)
    }
}
