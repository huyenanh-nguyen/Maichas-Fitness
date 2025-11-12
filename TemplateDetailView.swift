import SwiftUI

struct TemplateDetailView: View {
    var template: TemplateEntity
    
    var exercises: [WorkoutExercise] {
        guard let data = template.exercisesData as Data?,
              let decoded = try? JSONDecoder().decode([WorkoutExercise].self, from: data) else {
            return []
        }
        return decoded
    }
    
    var body: some View {
        List {
            ForEach(exercises) { exercise in
                Section(header: Text(exercise.name)) {
                    ForEach(exercise.sets) { set in
                        HStack {
                            Text("Reps: \(set.reps)")
                            Spacer()
                            Text("Weight: \(set.weight)")
                        }
                    }
                }
            }
        }
        .navigationTitle(template.name ?? "Template")
    }
}
