import SwiftUI
import CoreData

// MARK: - WorkoutExercise + WorkoutSet (Encodable & Decodable)
struct WorkoutExercise: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String = ""
    var bodyPart: String = ""
    var equipment: String = "Choose Equipment"
    var bodypart: String = "Choose Body Part"
    var sets: [WorkoutSet] = [WorkoutSet()]
}

struct WorkoutSet: Identifiable, Hashable, Codable {
    var id = UUID()
    var reps: String = ""
    var weight: String = ""
}

// MARK: - Workout Editor View
struct WorkoutEditorView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: true)]
    ) var workouts: FetchedResults<WorkoutEntity>

    var date: Date
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var exercises: [WorkoutExercise] = [WorkoutExercise()]
    @State private var notes: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text("Workout for \(date.formatted(date: .abbreviated, time: .omitted))")
                    .font(.title2)

                DatePicker("Start Time", selection: $startTime, displayedComponents: [.hourAndMinute])
                    .padding(.vertical, 4)

                ForEach($exercises) { $exercise in
                    ExerciseSection(exercise: $exercise)
                }

                Button("+ Add Exercise") {
                    exercises.append(WorkoutExercise())
                }
                .padding(.vertical)

                TextField("Notes (optional)", text: $notes, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom)

                DatePicker("End Time", selection: $endTime, displayedComponents: [.hourAndMinute])
                    .padding(.vertical, 4)

                Button("End Workout") {
                    saveWorkout()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("Workout Editor")
    }

    // MARK: - Save Workout
    private func saveWorkout() {
        let workout = WorkoutEntity(context: viewContext)
        workout.id = UUID()
        workout.date = date
        workout.startTime = startTime
        workout.endTime = endTime
        workout.notes = notes

        // 🧠 JSON speichern
        if let data = try? JSONEncoder().encode(exercises) {
            workout.exercisesData = data as NSData
        }

        do {
            try viewContext.save()
            print("✅ Workout gespeichert")
        } catch {
            print("❌ Error saving workout: \(error)")
        }
    }
}

// MARK: - Exercise Section
struct ExerciseSection: View {
    @Binding var exercise: WorkoutExercise

    let equipmentOptions = [
        "Barbells", "Dumbbells", "Kettlebells", "Bodyweight",
        "Machines", "Treadmills", "Resistance Bands", "Weight Plates",
        "Stairmasters", "Yoga Mat", "Other"
    ]

    let bodypartOptions = [
        "Chest (Pectorals)", "Front shoulders (Anterior deltoids)", "Biceps",
        "Forearms", "Abs (Rectus abdominis)", "Obliques", "Trapezius (Upper traps)",
        "Rear shoulders (Posterior deltoids)", "Lats (Latissimus dorsi)",
        "Rhomboids", "Triceps", "Lower back (Erector spinae)",
        "Glutes (Gluteus maximus)", "Hamstrings", "Quadriceps", "Adductors (Inner thighs)",
        "Abductors (Outer thighs)", "Calves (Gastrocnemius & Soleus)",
        "Hip flexors", "Tibialis anterior (Shin)", "Neck muscles",
        "Serratus anterior", "Infraspinatus", "Teres major", "Teres minor",
        "Rotator cuff (general)", "Spinal erectors", "Iliotibial band (IT band area)",
        "Peroneals (outer lower leg)", "Gluteus medius/minimus"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Exercise name", text: $exercise.name)
                .textFieldStyle(.roundedBorder)

            // Dropdown for Bodypart
            customMenu(
                title: exercise.bodypart.isEmpty ? "Select Body Part" : exercise.bodypart,
                options: bodypartOptions,
                selection: $exercise.bodypart
            )

            // Dropdown for Equipment
            customMenu(
                title: exercise.equipment.isEmpty ? "Select Equipment" : exercise.equipment,
                options: equipmentOptions,
                selection: $exercise.equipment
            )

            ForEach($exercise.sets) { $set in
                HStack {
                    TextField("Reps", text: $set.reps)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                    TextField("Weight", text: $set.weight)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                }
            }

            Button("+ Add Set") {
                exercise.sets.append(WorkoutSet())
            }
            .font(.caption)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }

    // MARK: - Custom Dropdown
    private func customMenu(title: String, options: [String], selection: Binding<String>) -> some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) {
                    selection.wrappedValue = option
                }
            }
        } label: {
            HStack {
                Text(title)
                    .foregroundColor(title.contains("Select") ? .gray : .primary)
                Spacer()
                Image(systemName: "chevron.down")
            }
            .padding(8)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            .cornerRadius(8)
        }
    }
}

// MARK: - Preview
struct WorkoutExerciseView_Previews: PreviewProvider {
    // Simple in-memory Core Data stack for previews
    private struct PreviewContext {
        static let container: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Maichas_Fitness")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Unresolved error loading preview store: \(error)")
                }
            }
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            return container
        }()
    }

    static var previews: some View {
        NavigationView {
            WorkoutEditorView(date: Date())
                .environment(\.managedObjectContext, PreviewContext.container.viewContext)
        }
    }
}
