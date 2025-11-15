import SwiftUI

struct TemplateDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var template: TemplateEntity
    @State private var showEditor = false

    var decodedExercises: [WorkoutExercise] {
        guard let data = template.exercisesData as Data?,
              let decoded = try? JSONDecoder().decode([WorkoutExercise].self, from: data)
        else { return [] }
        return decoded
    }

    var body: some View {
        VStack(spacing: 20) {
            Text(template.name ?? "Template")
                .font(.largeTitle)
                .padding()

            Button("Open Template") {
                showEditor = true
            }
            .buttonStyle(.borderedProminent)
        }
        .sheet(isPresented: $showEditor) {
            WorkoutEditorView(
                date: Date(),
                prefilledExercises: decodedExercises,
                isReadOnly: true
            )
            .environment(\.managedObjectContext, viewContext)
        }
    }
}
