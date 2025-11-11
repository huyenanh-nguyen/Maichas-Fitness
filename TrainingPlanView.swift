//import SwiftUI
//import CoreData
//
//struct TrainingPlanView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    
//    @FetchRequest(
//        entity: TrainingNote.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \TrainingNote.title, ascending: true)]
//    ) var notes: FetchedResults<TrainingNote>
//    
//    @State private var newPlanText: String = ""
//    
//    var body: some View {
//        NavigationView {
//            VStack(alignment: .leading) {
//                
//                // Eingabefeld für neue Trainingsplan-Notiz
//                Text("Create your Training Plan:")
//                    .font(.headline)
//                    .padding(.top)
//                
//                TextEditor(text: $newPlanText)
//                    .frame(height: 150)
//                    .border(Color.gray.opacity(0.5), width: 1)
//                    .padding(.bottom)
//                
//                Button(action: savePlan) {
//                    Text("Save")
//                        .font(.headline)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding(.bottom)
//                
//                Divider()
//                
//                Text("My Plan")
//                    .font(.headline)
//                    .padding(.bottom, 5)
//                
//                // Liste der gespeicherten Pläne
//                if notes.isEmpty {
//                    Text("List is Empty")
//                        .foregroundColor(.secondary)
//                        .padding(.top, 20)
//                } else {
//                    List {
//                        ForEach(notes, id: \.objectID) { note in
//                            VStack(alignment: .leading) {
//                                Text(note.content ?? "")
//                                    .lineLimit(2)
//                            }
//                        }
//
//                        .onDelete(perform: deletePlan)
//                    }
//                }
//                
//                Spacer()
//            }
//            .padding()
//            .navigationTitle("Training Plan")
//        }
//    }
//    
//    // Neue Notiz speichern
//    private func savePlan() {
//        guard !newPlanText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
//        
//        let plan = TrainingNote(context: viewContext)
//        plan.content = newPlanText
//        plan.date = Date()
//        
//        do {
//            try viewContext.save()
//            newPlanText = ""
//        } catch {
//            print("Error saving plan: \(error)")
//        }
//    }
//    
//    // Notiz löschen
//    private func deletePlan(at offsets: IndexSet) {
//        offsets.map { notes[$0] }.forEach(viewContext.delete)
//        do {
//            try viewContext.save()
//        } catch {
//            print("Error deleting plan: \(error)")
//        }
//    }
//}

import SwiftUI
import CoreData

struct TrainingPlanView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TrainingNote.date, ascending: false)]
    ) var notes: FetchedResults<TrainingNote>
    
    @State private var newPlanText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Eingabefeld für neue Trainingsplan-Notiz
                Text("Create your Training Plan:")
                    .font(.headline)
                    .padding(.top)
                
                TextEditor(text: $newPlanText)
                    .frame(height: 150)
                    .border(Color.gray.opacity(0.5), width: 1)
                    .padding(.bottom)
                
                Button(action: savePlan) {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom)
                
                Divider()
                
                Text("My Plans")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                // Liste der gespeicherten Pläne
                if notes.isEmpty {
                    Spacer()
                    Text("No plans yet")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    List {
                        ForEach(notes) { note in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(note.content ?? "")
                                    .font(.body)
                                if let date = note.date {
                                    Text(date, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deletePlan)
                    }
                    .listStyle(PlainListStyle()) // sorgt für sauberes Scrollen
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Training Plan")
        }
    }
    
    private func savePlan() {
        guard !newPlanText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let plan = TrainingNote(context: viewContext)
        plan.content = newPlanText
        plan.date = Date()

        do {
            try viewContext.save()
            newPlanText = ""
        } catch {
            print("Error saving plan: \(error)")
        }
    }

    
    // Notiz löschen
    private func deletePlan(at offsets: IndexSet) {
        offsets.map { notes[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            print("Error deleting plan: \(error)")
        }
    }
}

