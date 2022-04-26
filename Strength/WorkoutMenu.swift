//
//  WorkoutMenu.swift
//  Strength
//
//  Created by James Pollington on 04/03/2022.
//

import SwiftUI

struct WorkoutMenu: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var presentAddNewWorkout: Bool = false
    

    var body: some View {
        NavigationView {
            TemplateList(sortDescriptor: NSSortDescriptor(keyPath: \Template.created, ascending: false))
                .navigationTitle("Workout Templates")
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {
                    self.presentAddNewWorkout.toggle()
                        })
                        {
                            Image(systemName: "plus.circle.fill")
                        }.sheet(isPresented: $presentAddNewWorkout) {
                            AddTemplate(presentAddNewWorkout: self.$presentAddNewWorkout).environment(\.managedObjectContext, self.managedObjectContext)
                            }
                    }
                }
            
        }
    }
}

struct WorkoutMenu_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutMenu()
    }
}
