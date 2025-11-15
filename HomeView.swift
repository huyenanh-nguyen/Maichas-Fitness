//import SwiftUI
//
//struct HomeView: View {
//    @State private var selectedDate = Date()
//    @State private var showWorkoutEditor = false
//    
//    var body: some View {
//        VStack {
//            Text("Select a Day to Log Workout")
//                .font(.headline)
//            
//            DatePicker(
//                "Workout Date",
//                selection: $selectedDate,
//                displayedComponents: [.date]
//            )
//            .datePickerStyle(.graphical)
//            .padding()
//            
//            Button("Add / View Workout") {
//                showWorkoutEditor = true
//            }
//            .buttonStyle(.borderedProminent)
//            .padding()
//        }
//        .sheet(isPresented: $showWorkoutEditor) {
//            WorkoutEditorView(date: selectedDate)
//        }
//    }
//}

import SwiftUI
import CoreData
import Foundation

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: true)]
    ) private var workouts: FetchedResults<WorkoutEntity>
    
    @State private var selectedDate = Date()
    @State private var showWorkoutEditor = false
    @State private var showTemplatePicker = false
    @State private var prefilledExercises: [WorkoutExercise]? = nil

    private func hasWorkout(on date: Date) -> Bool {
        workouts.contains { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: date) }
    }

    var body: some View {
        VStack {
            Text("Select a Day to Log Workout")
                .font(.headline)

            // Optional: Custom Calendar highlighting dates with workouts
            DatePicker("Workout Date", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .tint(hasWorkout(on: selectedDate) ? .green : .accentColor) // 🔹 Farbe ändern
                .padding()

            Button("Add Workout") {
                showWorkoutEditor = true
            }
            .buttonStyle(.borderedProminent)
            .padding()

            Button("Add Workout from Template") {
                // 🔹 Hier öffnest du später dein Template Picker Sheet
            }
            .buttonStyle(.bordered)
        }
        .sheet(isPresented: $showWorkoutEditor) {   //$showWorkoutEditor
            WorkoutEditorView(
                    date: selectedDate,
                    prefilledExercises: prefilledExercises
                )
            .environment(\.managedObjectContext, viewContext)
        }
        
        .sheet(isPresented: $showTemplatePicker) {
            TemplatePickerView(onSelect: { selectedExercises in
           prefilledExercises = selectedExercises
           showWorkoutEditor = true
       })
        }

    }
}
