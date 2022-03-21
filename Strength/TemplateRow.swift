//
//  TemplateRow.swift
//  Strength
//
//  Created by James Pollington on 07/03/2022.
//

import SwiftUI
import CoreData

struct TemplateRow: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var template: Template
    @State var makeWorkout: Bool = false
    @State var showSummary: Bool = false
    @State var navActive: Bool = false
    
    var body: some View {
        
            HStack(spacing: 0) {
                Text(template.name ?? "")
                Spacer()
                Button(action: {self.showSummary.toggle()}){Image(systemName: "arrow.right").foregroundColor(.black)}
                .sheet(isPresented: $showSummary){
                    PreWorkoutSummaryView(template:template, showSummary: $showSummary, navActive:$navActive)
                }
            }.background(NavigationLink(destination: NewWorkoutPage(sortDescriptor: NSSortDescriptor(keyPath: \Workout.started, ascending: false)), isActive: $navActive ) {})
            .padding()
        
    }
    
  
}


struct TemplateRow_Previews: PreviewProvider {
        static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        static var previews: some View {
        let pTemplate = Template(context: moc)
        pTemplate.name = "Push"
        return TemplateRow(template: pTemplate)
    }
}
