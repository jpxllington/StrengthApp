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
    @State var keyboardVisible: Bool = false
    @State var menuVisible: Bool = false
    @State var summarySheetVisible: Bool = false
    @State var failed: Bool = false
    @State var warmup: Bool = false
    
    @FetchRequest var exerciseSets: FetchedResults<ExerciseSet>
    
    init(set: ExerciseSet) {
        self.set = set
        
        _exerciseSets = FetchRequest(
            entity: ExerciseSet.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseSet.order, ascending: true)], predicate: NSPredicate(format: "exercise == %@",set.exercise! ))
    }
    
    
    var body: some View {
            
        ZStack {
            VStack {
                HStack{
                    Image(systemName: "gear").onTapGesture {
                        withAnimation(menuVisible ? .none : .linear(duration: 0.1)){
                            menuVisible.toggle()
                        }
                    }
                    
                    ZStack {
                        Rectangle()
                            .cornerRadius(5)
                            .foregroundColor(failed ? warmup ? Color.orange : Color.red : warmup ? Color.yellow : Color("ListItem"))
                            .frame(width: 20)
                        Text(String(set.order))
                    }
                    
                    Section(header: Text("Weight:")){
                        TextField(String(set.weight), text: $weight)
                            .keyboardType(.decimalPad)
                            .background(Color("TextFieldBackground"))
                            .cornerRadius(5)
                            .multilineTextAlignment(.center)
                            .shadow(color: .gray, radius: 0, x: 0, y: 0)
                    }
                    Section(header: Text("Reps:")){
                        TextField(String(set.reps), text: $reps)
                            .keyboardType(.decimalPad)
                            .background(Color("TextFieldBackground"))
                            .cornerRadius(5)
                            .multilineTextAlignment(.center)
                            .shadow(color: Color("TextFieldBackground")	, radius: 0, x: 0, y: 0)
                    }
                    Image(systemName: saved ? "checkmark.seal.fill" : "checkmark.seal").onTapGesture {
                        validateData()
                        keyboardVisible = false
                    }
                }.onAppear(perform: {prefill()})
                .background(saved ? Color("SavedSet") : Color("ListItem"))
                    .cornerRadius(5)
                .padding(.vertical, 5)
                .frame(height:30)
                if menuVisible {
                    ZStack{
                        Rectangle()
                            .foregroundColor(Color("Background"))
                            .cornerRadius(5)
                        VStack{
                            HStack{
                               Image(systemName: "xmark.bin.fill")
                               Text("Delete Set")
                               Spacer()
                            }.onTapGesture {
                               deleteSet()
                            }.padding(10)
                            HStack{
                               Image(systemName: "xmark.bin.fill")
                               Text("Show Exercise Summary")
                               Spacer()
                            }.onTapGesture {
                                summarySheetVisible.toggle()
                            }.padding(10)
                            HStack{
                               Image(systemName: "xmark.bin.fill")
                               Text("Mark as Failed")
                               Spacer()
                            }.onTapGesture {
                                menuVisible.toggle()
                                failed.toggle()
                            }.padding(10)
                            HStack{
                               Image(systemName: "xmark.bin.fill")
                               Text("Mark as Warmup")
                               Spacer()
                            }.onTapGesture {
                                menuVisible.toggle()
                                warmup.toggle()
                            }.padding(10)
                        }
                    }.transition(.scale)
                }
            }
            .sheet(isPresented: $summarySheetVisible) {
                ExerciseStatsView(exerciseDetails: (set.exercise?.exerciseDetails)!)
            }
        }
        
            
    }
    
    func prefill() {
        self.reps = String(set.reps)
        self.weight = String(set.weight)
        self.saved = set.saved
        self.failed = set.failure
        self.warmup = set.warmUp
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
        set.warmUp = warmup
        set.failure = failed
        self.saved.toggle()
        set.saved = self.saved
        if managedObjectContext.hasChanges {
            do{
                try managedObjectContext.save()
                
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
