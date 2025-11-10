//import SwiftUI
//import CoreData
//
//struct AddNoteView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    @Environment(\.dismiss) private var dismiss
//    @State private var title = ""
//    @State private var content = ""
//
//    var body: some View {
//        NavigationView {
//            Form {
//                // Hier das Title-Feld
//                TextField("Title", text: $title)
//                
//                // Hier das Content-Feld
//                TextEditor(text: $content)
//                    .frame(minHeight: 200)
//            }
//            .navigationTitle("New Note")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") { dismiss() }
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Save") {
//                        let newNote = TrainingNote(context: viewContext)
//                        newNote.id = UUID()
//                        newNote.title = title
//                        newNote.content = content
//                        newNote.date = Date()
//                        
//                        do {
//                            try viewContext.save()
//                            dismiss()
//                        } catch {
//                            print(error)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
