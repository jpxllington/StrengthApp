//
//  ExerciseSetView.swift
//  Strength
//
//  Created by James Pollington on 09/03/2022.
//

import SwiftUI
import CoreData

struct ExerciseSetView: View {
    @ObservedObject var set: ExerciseSet
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var weight: String = ""
    @State var reps: String = ""
    @State var saved: Bool = false
    @State var numericWeight: Double = 0
    @State var numericReps: Int64 = 0
    let screenSize = UIScreen.main.bounds
    
    @FetchRequest var exerciseSets: FetchedResults<ExerciseSet>
    
    init(set: ExerciseSet) {
        self.set = set
        
        _exerciseSets = FetchRequest(
            entity: ExerciseSet.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseSet.order, ascending: true)], predicate: NSPredicate(format: "exercise == %@",set.exercise!))
    }
    
    
    var body: some View {
            VStack {
                HStack{
                    Image(systemName: "gear").onTapGesture {
                        deleteSet()
                    }
                    Spacer()
                    Text(String(set.order))
                    Spacer()
                    Spacer()
                    Section(header: Text("Weight:")){
                        TextField(String(set.weight), text: $weight)
                    }
                    Section(header: Text("Reps:")){
                        TextField(String(set.reps), text: $reps)
                    }
                    Image(systemName: saved ? "checkmark.seal.fill" : "checkmark.seal").onTapGesture {
                        validateData()
                    }
                }
            }
        
            
    }
    func deleteSet(){
       
        managedObjectContext.delete(set)
        if managedObjectContext.hasChanges {
            do{
                try managedObjectContext.save()
                updateOrder()
            } catch {
                print(error)
            }
        }
    }
    func updateOrder(){

        if(exerciseSets.count > 0){
            exerciseSets[0].order = 1
        }
        if(exerciseSets.count > 1){
            for index in 0...exerciseSets.count - 1{
                exerciseSets[index].order = Int64(index + 1)
            }
        }
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    
    func validateData(){
        weight = weight.trimmingCharacters(in: .whitespacesAndNewlines)
        reps = reps.trimmingCharacters(in: .whitespacesAndNewlines)
        
        numericWeight = Double(self.weight) ?? 0
        numericReps = Int64(self.reps) ?? 0
        
        saveSet()
        
    }
    
    func saveSet(){
        set.weight = numericWeight
        set.reps = numericReps
        
        if managedObjectContext.hasChanges {
            do{
                try managedObjectContext.save()
                self.saved.toggle()
            }catch {
                print(error)
            }
        }
    }
}

struct ExerciseSetView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let pSet = ExerciseSet(context: moc)
        pSet.order = 1
        pSet.weight = 80
        pSet.reps = 10
        return ExerciseSetView(set: pSet)
    }
}
