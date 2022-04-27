//
//  AddExercise.swift
//  Strength
//
//  Created by James Pollington on 08/03/2022.
//

import SwiftUI
import CoreData

struct AddExercise: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var workout: Workout
    @Binding var presentAddNewExercise: Bool
    @State var name: String = ""
    @State var bodyPart: String = ""
    
    @State private var errorMessage = ""
    @State private var showValidationError = false
    @State private var selectedExercise = 0
    @State private var newExerciseForm = false
    
    @FetchRequest(
        entity: ExerciseDetails.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseDetails.name, ascending: true)]) var exercises: FetchedResults<ExerciseDetails>

    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color("AddExercise"))
                .frame(maxHeight: newExerciseForm ? screenSize.height * 0.4 : screenSize.height * 0.5)
                .frame(width: screenSize.width * 0.85)
                .onTapGesture(perform: {self.hideKeyboard()})
            VStack{
                HStack(alignment: .top){
                    Button(action: {presentAddNewExercise = false }, label: {Text("Cancel")})
                    Spacer()
                    Text("Add Exercise").font(.title2)
                    Spacer()
                    Button(action: {validateData()}, label: {Text("Add")})
                }.padding(.horizontal, 20)
                    .padding(.vertical, 25)
                    .frame(width: screenSize.width * 0.8)
                    .foregroundColor(.white)
                
                if exercises.count != 0 {
                    Button(action: {
                        withAnimation(.easeInOut){
                            newExerciseForm.toggle()
                        }
                        
                    }, label: {
                        HStack{
                            Spacer()
                            Text(newExerciseForm ? "Exercise Picker" : "Create New Exercise")
                            Spacer()
                        }.padding(.vertical,5).foregroundColor(.white).background(Color("TabBar")).clipShape(RoundedRectangle(cornerRadius: 10))
                    }).frame(width: screenSize.width * 0.8)
                }
                Spacer()
                if(newExerciseForm == false){
                    if exercises.count == 0 {
                        Text("No Saved Exercises")
                    } else{
                        Divider()
                        Picker("Exercise", selection: $selectedExercise){
                            ForEach(exercises.indices) { index in
                                Text(exercises[index].name ?? "").tag(index)
                            }.foregroundColor(.black)
                        }.pickerStyle(.wheel).background(Color("TextFieldBackground").clipShape(RoundedRectangle(cornerRadius: 15)))
                        Text("Selected: \(exercises[selectedExercise].name ?? "")").foregroundColor(.white)
//                        Spacer()
                    }
                }
                if(!newExerciseForm){
                    Spacer()
                }
                
                if(newExerciseForm){
                    Divider()
                    Section(header: Text("Name").foregroundColor(.white)){
                        TextField("Enter Name", text: $name)
                            .background(Color("TextFieldBackground"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(5)
                            .multilineTextAlignment(.center)
                    }
                    Section(header: Text("Body Part").foregroundColor(.white)) {
                        TextField("Enter Body Part", text: $bodyPart )
                            .background(Color("TextFieldBackground"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(5)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                }
                
            }
                .frame(maxHeight: newExerciseForm ? screenSize.height * 0.4 : screenSize.height * 0.5)
                .frame(width: screenSize.width * 0.8)
                .onTapGesture(perform: {self.hideKeyboard()})
            .alert(isPresented: $showValidationError, content: { () -> Alert in
                Alert(title: Text("error"), message: Text(errorMessage), dismissButton: .default(Text("Okay")))
            })
            .onAppear {
                countExercises()
            }
        }
    }
//        NavigationView {
//            Form {
//                if(newExerciseForm == false){
//                    Section(header: Text("Workout")){
//
//                        if exercises.count == 0 {
//                            Text("No saved exercises")
//                        } else {
//                            Picker("Workout", selection: $selectedExercise){
//                                ForEach(exercises.indices) { index in
//                                    Text(exercises[index].name ?? "").tag(index)
//                                }
//
//                            }.pickerStyle(.wheel)
//                                .frame(width: screenSize.width * 0.6)
//
//                            Text("Selected: \(exercises[selectedExercise].name ?? "")")
//                        }
//                    }
//                }
//                if exercises.count != 0 {
//                    Button(action: {newExerciseForm.toggle()}, label:{
//                        HStack{
//                            Spacer()
//                            Text(newExerciseForm ? "Exercise Picker" : "Create New Exercise")
//                            Spacer()
//                        }
//
//                    })
//                }
//                if(newExerciseForm){
//                    Section(header: Text("Name")) {
//                        TextField("Enter Name", text: $name)
//                    }
//                    Section(header: Text("Body Part")) {
//                        TextField("Enter Body Part", text: $bodyPart )
//                    }
//                }
//            }
//            .navigationTitle("Add New Exercise").font(.title3)
//            .navigationBarItems(leading: Button(action: {presentAddNewExercise = false}, label: {Text("Cancel")})
//                                    ,trailing:
//                                    Button(action: {
//                self.validateData()
//            }) {
//                Text("Save")
//            }
//
//            )
//            .alert(isPresented: $showValidationError, content: { () -> Alert in
    //                Alert(title: Text("error"), message: Text(errorMessage), dismissButton: .default(Text("Okay")))
    //            })
//            .onAppear {
//                countExercises()
//            }
//        }
//    }
    
    func countExercises() {
        if exercises.count == 0 {
            newExerciseForm = true
        }
    }
    
    func dismissView() {
        self.presentAddNewExercise = false
    }
    
    func validateData(){
        if(newExerciseForm == true){
            if exercises.count >= 1{
                for index in 0...exercises.count - 1 {
                    let exerciseName = String(exercises[index].name ?? "")
                    if (exerciseName == name) {
                        errorMessage = "This exercise already exists"
                        showValidationError.toggle()
                    }
                }
            }
            name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            bodyPart = bodyPart.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if name.isEmpty {
                errorMessage = "Exercise Name Required"
                showValidationError.toggle()
            } else if bodyPart.isEmpty {
                errorMessage = "Body Part Required"
                showValidationError.toggle()
            }else {
                saveExercise()
            }
        } else {
            
            let newExercise = Exercise(context: managedObjectContext)
            newExercise.exerciseDetails = exercises[selectedExercise]
            newExercise.workout = workout
            newExercise.displayOrder = Int64(workout.exercises?.count ?? 0 + 1)
            let newSet = ExerciseSet(context: managedObjectContext)
            newSet.reps = 0
            newSet.weight = 0
            newSet.order = 1
            newExercise.addToExerciseSets(newSet)
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                    self.dismissView()
                }catch{
                    print(error)
                }
            }
        }
        
    }
    
    func saveExercise() {
        let newExercise = Exercise(context: managedObjectContext)
        let newExerciseDetails = ExerciseDetails(context: managedObjectContext)
        newExerciseDetails.name = name
        newExerciseDetails.bodyPart = bodyPart
        newExercise.exerciseDetails = newExerciseDetails
        newExercise.workout = workout
        newExercise.displayOrder = Int64(workout.exercises?.count ?? 0 + 1)
        let newSet = ExerciseSet(context: managedObjectContext)
        newSet.reps = 0
        newSet.weight = 0
        newSet.order = 1
        newExercise.addToExerciseSets(newSet)
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                self.dismissView()
            }catch{
                print(error)
            }
        }
    }
}

struct AddExercise_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
    let pWorkout = Workout(context: moc)
    pWorkout.name = "Push"
        return AddExercise(workout: pWorkout, presentAddNewExercise: .constant(true))
    }
}
