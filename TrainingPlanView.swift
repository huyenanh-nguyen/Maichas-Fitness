import SwiftUI
import CoreData

struct TrainingPlanView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TrainingNote.date, ascending: true)]
    ) var notes: FetchedResults<TrainingNote>
    
    @State private var newPlanText: String = ""
    @State private var selectedNote: TrainingNote? = nil
    @State private var showDetail = false
    
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
                
                // Scrollable List
                if notes.isEmpty {
                    Text("List is Empty")
                        .foregroundColor(.secondary)
                        .padding(.top, 20)
                } else {
                    List {
                        ForEach(notes, id: \.id) { note in
                            VStack(alignment: .leading) {
                                Text(note.content ?? "")
                                    .lineLimit(3)
                                    .padding(.vertical, 4)
                                Text("Created at: \(note.date ?? Date(), formatter: itemFormatter)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .contentShape(Rectangle())
//                            .onTapGesture {
//                                selectedNote = note
//                                showDetail = true
//                            }
                            .onTapGesture {
                                selectedNote = note
                            }

                        }
                        .onDelete(perform: deleteNotes)
                    }
                    .sheet(item: $selectedNote) { note in
                        NoteEditView(note: note)
                            .environment(\.managedObjectContext, viewContext)
                    }

                    .listStyle(PlainListStyle())
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Training Plan")
            .sheet(item: $selectedNote) { note in
                NoteEditView(note: note)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    private var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    // Neue Notiz speichern
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
    
    // Swipe-to-delete
    private func deleteNotes(at offsets: IndexSet) {
        offsets.map { notes[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            print("Error deleting plan: \(error)")
        }
    }
}

// Editierbare Detailansicht
struct NoteEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var note: TrainingNote
    @Environment(\.presentationMode) var presentationMode
    @State private var editedContent: String = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextEditor(text: $editedContent)
                    .frame(height: 300)
                    .border(Color.gray.opacity(0.5), width: 1)
                    .padding()

                Text("Created at: \(note.date ?? Date(), formatter: itemFormatter)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Edit Note")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    note.content = editedContent
                    do {
                        try viewContext.save()
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print("Error saving edited note: \(error)")
                    }
                }
            )
            .onAppear {
                editedContent = note.content ?? ""
            }
        }
    }

    private var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }
}
