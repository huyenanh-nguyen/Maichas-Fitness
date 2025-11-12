import SwiftUI
import CoreData

struct TemplatePickerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TemplateEntity.name, ascending: true)]
    ) private var templates: FetchedResults<TemplateEntity>
    
    var onSelect: ([WorkoutExercise]) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(templates) { template in
                    Button(action: {
                        if let data = template.exercisesData as Data?,
                           let exercises = try? JSONDecoder().decode([WorkoutExercise].self, from: data) {
                            onSelect(exercises)
                            dismiss()
                        }
                    }) {
                        Text(template.name ?? "Unnamed Template")
                    }
                }
            }
            .navigationTitle("Select Template")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
