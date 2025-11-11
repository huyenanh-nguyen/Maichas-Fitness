import SwiftUI

struct WorkoutExercise: Identifiable, Hashable {
    var id = UUID()
    var name: String = ""
    var bodyPart: String = ""
    var equipment: String = "Bodyweight"
    var bodypart: String = "Glutes (Gluteus maximus)"
    var sets: [WorkoutSet] = [WorkoutSet()]
}

struct WorkoutSet: Identifiable, Hashable {
    var id = UUID()
    var reps: String = ""
    var weight: String = ""
}

struct WorkoutEditorView: View {
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
                DatePicker("End Time", selection: $endTime, displayedComponents: [.hourAndMinute])
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
                
                Button("End Workout") {
                    // TODO: Save workout to data model
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("Workout Editor")
    }
}

struct ExerciseSection: View {
    @Binding var exercise: WorkoutExercise
    @State private var showEquipmentSheet = false
    @State private var showBodypartSheet = false
    
    let equipmentOptions = ["Barbells",
                            "Dumbbells",
                            "Kettlebells",
                            "Bodyweight",
                            "Machines",
                            "Treadmills",
                            "Resistance Bands",
                            "weight plates",
                            "Stairmasters",
                            "Yoga Mat", "Other"]
    
    let BodypartOptions = [
        "Chest (Pectorals)",
        "Front shoulders (Anterior deltoids)",
        "Biceps",
        "Forearms",
        "Abs (Rectus abdominis)",
        "Obliques",
        "Trapezius (Upper traps)",
        "Rear shoulders (Posterior deltoids)",
        "Lats (Latissimus dorsi)",
        "Rhomboids",
        "Triceps",
        "Lower back (Erector spinae)",
        "Glutes (Gluteus maximus)",
        "Hamstrings",
        "Quadriceps",
        "Adductors (Inner thighs)",
        "Abductors (Outer thighs)",
        "Calves (Gastrocnemius & Soleus)",
        "Hip flexors",
        "Tibialis anterior (Shin)",
        "Neck muscles",
        "Serratus anterior",
        "Infraspinatus",
        "Teres major",
        "Teres minor",
        "Rotator cuff (general)",
        "Spinal erectors",
        "Iliotibial band (IT band area)",
        "Peroneals (outer lower leg)",
        "Gluteus medius/minimus"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Exercise name", text: $exercise.name)
                .textFieldStyle(.roundedBorder)
            
//         Dropdown for the Bodypart
            Menu {
                    ForEach(BodypartOptions, id: \.self) { option in
                        Button(option) {
                            exercise.bodypart = option
                        }
                    }
                } label: {
                    HStack {
                        Text(exercise.bodypart.isEmpty ? "Select Body Part" : exercise.bodypart)
                            .foregroundColor(exercise.bodypart.isEmpty ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .padding(8)
                    .background(Color.white)
                    .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1) // optional: Rand wie TextField
                            )
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity) // dropdownmenu as wide as the rest of the screen
                
//              Dropdown for the Equiptment
                Menu {
                    ForEach(equipmentOptions, id: \.self) { option in
                        Button(option) {
                            exercise.equipment = option
                        }
                    }
                } label: {
                    HStack {
                        Text(exercise.equipment)
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .padding(8)
                    .background(Color.white)
                    .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1) // optional: Rand wie TextField
                            )
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity)
            
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
}

struct WorkoutExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WorkoutEditorView(date: Date())
        }
    }
}
