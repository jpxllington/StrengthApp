//
//  SummaryPage.swift
//  Strength
//
//  Created by James Pollington on 22/03/2022.
//

import SwiftUI
import CoreData
struct SummaryPage: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: ExerciseDetails.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseDetails.name, ascending: true)]) var exercises: FetchedResults<ExerciseDetails>
    
    
    
    var body: some View {
        NavigationView {
            if exercises.count == 0 {
                Text("You must complete a workout first")
                    .navigationTitle("Exercise Summaries")
            } else {
                    List {
                        ForEach (exercises) { exercise in
                            VStack {
                                Spacer(minLength: 15)
                                ZStack {
                                    Rectangle()
                                       .foregroundColor(Color("ListItem"))
                                       .cornerRadius(20)
//                                       .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
//                                       .border(Color("Shadow"), width: 2, cornerRadius: 10)
                                       .padding(.horizontal, -7)
                                       .padding(.vertical, -15)
                                       .overlay(
                                           Capsule(style: .continuous)
                                            .stroke(Color("Shadow"), lineWidth: 2)
                                            .padding(.horizontal, -7)
                                            .padding(.vertical, -15))
                                    NavigationLink(destination: ExerciseStatsView(exerciseDetails: exercise)) {
                                        Text(exercise.name!)
                                            
                                    }
                                }
                                Spacer(minLength: 20)
                            }
                        }
                        .listRowSeparator(.hidden)
//                            .listRowBackground(Color.green)
                    }
                    .listStyle(.inset)
                .navigationTitle("Exercise Summaries")
                
            }
        }
    }
}



struct SummaryPage_Previews: PreviewProvider {
    static var previews: some View {
        SummaryPage()
    }
}
