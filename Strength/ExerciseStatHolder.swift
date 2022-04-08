//
//  ExerciseStatHolder.swift
//  Strength
//
//  Created by James Pollington on 23/03/2022.
//

import SwiftUI


struct ExerciseStatHolder: View {
    let screenSize = UIScreen.main.bounds
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var titleText: String
    @Binding var dataText: String
    
    var body: some View {
        ZStack {
            Rectangle().frame(width: (screenSize.width * 4.5 / 10), height: (screenSize.width * 4.5 / 10))
                
                .foregroundColor(Color("ListItem"))
                .cornerRadius(20)
                .shadow(color: Color("Shadow"), radius: 4, x: 0, y: 3)
            VStack{
                HStack{
                    Text(titleText)
                        .font(.subheadline)
                        .padding(.horizontal)
                    Spacer()
                }.padding(.vertical)
                HStack{
                    Spacer()
                    Text(dataText)
                        .fontWeight( .semibold).font(.system(size: titleText == "Most recent set" ? 20 : 40))
                    Spacer()
                }
                Spacer()
                
            }.padding()
                .frame(width: (screenSize.width/2), height: (screenSize.width/2))
        }
    }
}

struct ExerciseStatHolder_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseStatHolder(titleText: "Number of sets completed", dataText: .constant("6"))
    }
}
