//
//  WorkoutEditorBar.swift
//  Yuen Fitness
//
//  Created by Huyen Anh Nguyen on 10.11.25.
//

import SwiftUI

struct WorkoutExercise: Identifiable, Hashable {
    var id = UUID()
    var name: String = ""
    var bodyPart: String = ""
    var equipment: String = "Bodyweight"
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
    @State private var exercises: [WorkoutExercise] = [WorkoutExercise()]
    @State private var notes: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Workout for \(date.formatted(date: .abbreviated, time: .omitted))")
                    .font(.title2)
                
                DatePicker("Start Time", selection: $startTime, displayedComponents: [.hourAndMinute])
                    .padding(.vertical)
                
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
    
    let equipmentOptions = ["Bar", "Dumbbells", "Kettlebells", "Bodyweight"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Exercise name", text: $exercise.name)
                .textFieldStyle(.roundedBorder)
            
            TextField("Body part", text: $exercise.bodyPart)
                .textFieldStyle(.roundedBorder)
            
            Picker("Equipment", selection: $exercise.equipment) {
                ForEach(equipmentOptions, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(.segmented)
            
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
