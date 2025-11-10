import Foundation
import CoreData

@objc(TrainingNote)
public class TrainingNote: NSManagedObject {}
extension TrainingNote: Identifiable {}

extension TrainingNote {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingNote> {
        return NSFetchRequest<TrainingNote>(entityName: "TrainingNote")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var date: Date?
}
