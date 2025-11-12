import SwiftUI

struct TemplateListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TemplateEntity.name, ascending: true)]
    ) private var templates: FetchedResults<TemplateEntity>

    var body: some View {
        List {
            ForEach(templates) { template in
                NavigationLink(destination: TemplateDetailView(template: template)) {
                    Text(template.name ?? "Unnamed Template")
                }
            }
        }
    }
}
