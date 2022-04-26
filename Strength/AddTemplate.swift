//
//  AddWorkout.swift
//  Strength
//
//  Created by James Pollington on 04/03/2022.
//

import SwiftUI

struct AddTemplate: View {
    @Binding var presentAddNewWorkout: Bool
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var name: String = ""
    @State var notes: String = ""
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Workout Name")) {
                    TextField("Enter name", text: $name)
                }
            }
            .navigationBarTitle(Text("New Workout Template"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {self.validateData()}) {
                    Text("Save")
                })
        }
        
    }
    func dismissView() {
        self.presentAddNewWorkout = false
    }
    
    func validateData(){
        name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if name.isEmpty {
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .long
            
            name = "New Workout " + formatter.string(from: currentDateTime)
        }
        saveWorkout()
    }
    
    func saveWorkout() {
        let newTemplate = Template(context: managedObjectContext)
        newTemplate.name = self.name
        
        newTemplate.created = Date()
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                dismissView()
                
            } catch {
                print(error)
            }
        }
    }
}

struct AddWorkout_Previews: PreviewProvider {
    static var previews: some View {
        AddTemplate(presentAddNewWorkout: .constant(false) )
    }
}
