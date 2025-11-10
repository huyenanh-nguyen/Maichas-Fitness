import SwiftUI
import CoreData

struct TrainingPlanView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TrainingNote.date, ascending: true)],
        animation: .default
    )
    private var notes: FetchedResults<TrainingNote>
    
    @State private var newPlanText: String = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
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
                
                Text("My Plan")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                // Liste der gespeicherten Pläne
                if notes.isEmpty {
                    Text("List is Empty")
                        .foregroundColor(.secondary)
                        .padding(.top, 20)
                } else {
                    List {
                        ForEach(notes, id: \.id) { note in
                            VStack(alignment: .leading) {
                                Text(note.content ?? "")
                                    .lineLimit(2)
                            }
                        }
                        .onDelete(perform: deletePlan)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Training Plan")
        }
    }
    
    // Neue Notiz speichern
    private func savePlan() {
        guard !newPlanText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let plan = TrainingNote(context: viewContext)
        plan.id = UUID()
        plan.content = newPlanText
        plan.date = Date()
        
        do {
            try viewContext.save()
            newPlanText = "" // Eingabefeld leeren
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
