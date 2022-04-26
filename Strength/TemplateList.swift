//
//  TemplateList.swift
//  Strength
//
//  Created by James Pollington on 07/03/2022.
//

import SwiftUI
import CoreData

struct TemplateList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Template.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Template.created, ascending: false)]) var templates: FetchedResults<Template>
    
    
    init(sortDescriptor: NSSortDescriptor) {
        let fetchRequest = NSFetchRequest<Template>(entityName: Template.entity().name ?? "Template" )
        fetchRequest.sortDescriptors = [sortDescriptor]

        _templates = FetchRequest(fetchRequest: fetchRequest)
    }
    
    
    var body: some View {
        if templates.count == 0 {
            Text("No Templates Added")
        } else {
            ZStack {
                Color.blue
                List{
                    ForEach(templates) { template in
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color("ListItem"))
                                .cornerRadius(20)
                                .shadow(color: Color("Shadow").opacity(0.1), radius: 3, x: 0, y: 3)
                            
                            TemplateRow(template:template)
                        }
                    }.onDelete(perform: deleteTemplate)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.inset)
                
                .background(Color.blue)
            }
        }
    }
    
    func deleteTemplate(at offsets: IndexSet){
        for index in offsets {
            let template = templates[index]
            managedObjectContext.delete(template)
            if managedObjectContext.hasChanges{
                do{
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }
    
}

struct TemplateList_Previews: PreviewProvider {
    static var previews: some View {
        TemplateList(sortDescriptor: NSSortDescriptor(keyPath: \Template.created, ascending: true))
    }
}
