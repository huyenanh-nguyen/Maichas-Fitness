//
//  NewExcersiceView.swift
//  Yuen Fitness
//
//  Created by Huyen Anh Nguyen on 10.11.25.
//

import SwiftUI

struct NewExerciseView: View {
    @State private var selectedDate = Date()
    @State private var showWorkoutEditor = false
    
    var body: some View {
        VStack {
            Text("Select a Day to Log Workout")
                .font(.headline)
            
            DatePicker(
                "Workout Date",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .padding()
            
            Button("Add / View Workout") {
                showWorkoutEditor = true
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .sheet(isPresented: $showWorkoutEditor) {
            WorkoutEditorView(date: selectedDate)
        }
    }
}
