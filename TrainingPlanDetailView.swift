import SwiftUI
import CoreData

struct TrainingPlanDetailView: View {
    @ObservedObject var note: TrainingNote
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var editedText: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Edit Your Plan")
                .font(.headline)
                .padding(.bottom, 8)
            
            TextEditor(text: $editedText)
                .padding()
                .border(Color.gray.opacity(0.4), width: 1)
                .frame(minHeight: 200)
            
            Spacer()
            
            HStack {
                Button(role: .destructive) {
                    deleteNote()
                } label: {
                    Label("Delete", systemImage: "trash")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button {
                    saveNote()
                } label: {
                    Label("Save", systemImage: "square.and.arrow.down")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .navigationTitle("Training Plan Detail")
        .onAppear {
            editedText = note.content ?? ""
        }
    }
    
    private func saveNote() {
        note.content = editedText
        note.date = Date()
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving note: \(error)")
        }
    }
    
    private func deleteNote() {
        viewContext.delete(note)
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error deleting note: \(error)")
        }
    }
}

