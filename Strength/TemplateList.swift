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
        }
        List{
            ForEach(templates) { template in
                TemplateRow(template:template)
            }.onDelete(perform: deleteTemplate)
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
