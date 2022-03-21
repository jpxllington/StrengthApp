//
//  WorkoutView.swift
//  Strength
//
//  Created by James Pollington on 07/03/2022.
//

import SwiftUI
import CoreData

struct WorkoutView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.editMode) private var editMode
    @ObservedObject var workout: Workout
    @State var presentAddNewExercise: Bool = false
    @State var isTimerRunning = false
    @State var interval = TimeInterval()
    @State var showAlert: Bool = false
    @State var workoutStart: Date = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    let screenSize = UIScreen.main.bounds
    
    @FetchRequest var exercises: FetchedResults<Exercise>
    
    init(workout: Workout) {
        self.workout = workout
        _exercises = FetchRequest(
            entity: Exercise.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.displayOrder, ascending: true)], predicate: NSPredicate(format: "workout == %@",workout))
    }
    
    var body: some View {
        
        if workout.exercises?.count == 0 {
                Text("No exercises added")
            }
        VStack{
            
            List{
               ForEach(exercises) { exercise in
                   ExerciseView(exercise: exercise)
               }.onMove(perform: moveWorkout)
                    .padding(.leading, self.editMode?.wrappedValue.isEditing ?? false ? -45 : 0)
//                ForEach(Array(workout.exercises as? Set<Exercise> ?? [] ), id: \.self) { exercise in
//                    ExerciseView(exercise: exercise)
//
//                }
                
            }.listStyle(.inset)
            if(editMode?.wrappedValue.isEditing == true){
                HStack {
                    Spacer()
                    Text("Delete Workout").onTapGesture {
                        deleteWorkout()
                    }.foregroundColor(.red)
                    Spacer()
                }
            }
        }
//        List(Array(workout.exercises as? Set<Exercise> ?? [] ), id: \.self) { exercise in
//            ExerciseView(exercise: exercise)
//        }
        .navigationBarItems(trailing:
                                HStack(spacing: 20) {
            
            Text(formatter.string(from: interval) ?? "")
                .onReceive(timer) {_ in
                    if self.isTimerRunning {
                        interval = Date().timeIntervalSince(workoutStart)
                    }
                }
            Button(action: {showAlert.toggle()}, label: {Text("Finish")})
                .alert("Would you like to update the template?", isPresented: $showAlert){
                    Button("Yes"){
                        finishWorkout()
                        updateTemplate()
                    }
                    Button("No"){
                        finishWorkout()
                    }
                }
            EditButton()
            Button(action: {
                self.presentAddNewExercise.toggle()
            }) {
                Image(systemName: "plus.circle.fill")
            }.sheet(isPresented: $presentAddNewExercise) {
                AddExercise(workout:workout, presentAddNewExercise: self.$presentAddNewExercise)
            }
                    
        })
        
        .navigationBarTitle(workout.name ?? "")
        .font(.subheadline)
        .onAppear(perform: {if workout.workoutLive == true {
            isTimerRunning = true
            workoutStart = workout.started!
        }})
    }
    
    func moveWorkout(from source: IndexSet, to destination: Int){
        var revisedItems: [ Exercise ] = exercises.map{ $0 }

            // change the order of the items in the array
            revisedItems.move(fromOffsets: source, toOffset: destination )

            // update the userOrder attribute in revisedItems to
            // persist the new order. This is done in reverse order
            // to minimize changes to the indices.
            for reverseIndex in stride( from: revisedItems.count - 1,
                                        through: 0,
                                        by: -1 )
            {
                revisedItems[ reverseIndex ].displayOrder =
                    Int64( reverseIndex )
            }
        if managedObjectContext.hasChanges{
            do{
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    func deleteWorkout(){
        managedObjectContext.delete(workout)
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    func finishWorkout(){
        let finishTime = Date()
        workout.finished = finishTime
        workout.workoutLive = false
        isTimerRunning = false
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    func updateTemplate(){
        let template = workout.template
        for exercise in template!.exercises ?? []{
            managedObjectContext.delete(exercise as! NSManagedObject)
        }
        for exercise in exercises {
            print(exercise)
            let newExercise = TemplateExercise(context: managedObjectContext)
            newExercise.exerciseDetails = exercise.exerciseDetails
            newExercise.displayOrder = exercise.displayOrder
            for exerciseSet in exercise.exerciseSets!  {
//                    print(exerciseSet)
//                    print((exerciseSet as AnyObject).weight)
//                    print((exerciseSet as AnyObject).reps)
                let newTemplateSet = TemplateExerciseSet(context: managedObjectContext)
                newTemplateSet.weight = (exerciseSet as AnyObject).weight
                newTemplateSet.reps = (exerciseSet as AnyObject).reps
                newTemplateSet.order = (exerciseSet as AnyObject).order
                newExercise.addToTemplateExerciseSet(newTemplateSet)
            }
            template?.addToExercises(newExercise)
        }
//
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
}



struct WorkoutView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let pWorkout = Workout(context: moc)
        pWorkout.name = "push"
        let pExercise = Exercise(context: moc)
        pExercise.name = "bench"
        pWorkout.addToExercises(pExercise)
        let pSet = ExerciseSet(context: moc)
        pSet.weight = 80
        pSet.reps = 10
        pExercise.addToExerciseSets(pSet)
        return WorkoutView(workout: pWorkout)
    }
}