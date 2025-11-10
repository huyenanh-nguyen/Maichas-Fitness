//import SwiftUI
//import CoreData
//
//struct NoteEditorView: View {
//    @ObservedObject var note: TrainingNote
//    @Environment(\.managedObjectContext) private var viewContext
//    @Environment(\.dismiss) private var dismiss
//
//    var body: some View {
//        Form {
//            TextField("Title", text: Binding(
//                get: { note.title ?? "" },
//                set: { note.title = $0 }
//            ))
//            TextEditor(text: Binding(
//                get: { note.content ?? "" },
//                set: { note.content = $0 }
//            ))
//            .frame(minHeight: 200)
//
//        }
//        .navigationTitle("Edit Note")
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button("Save") {
//                    do {
//                        try viewContext.save()
//                        dismiss()
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//        }
//    }
//}
//
//
//extension Binding where Value == String? {
//    init(_ source: Binding<String?>, replacingNilWith defaultValue: String) {
//        self.init(
//            get: { source.wrappedValue ?? defaultValue },
//            set: { source.wrappedValue = $0 }
//        )
//    }
//}
