import SwiftData
import Foundation

@Model
class GroupRecord: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var createdAt: Date
    
    init(name: String) {
        self.name = name
        self.createdAt = Date()
    }

    static func fetchGroup(_ context: ModelContext, groupID: UUID) -> [PasswordRecord] {
        let fetchDescriptor = FetchDescriptor<PasswordRecord>(
            predicate: #Predicate { record in
                record.group?.id == groupID
            }
        )
        
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Error fetching passwords for group \(groupID): \(error)")
            return []
        }
    }
    
    static func fetchAll(_ context: ModelContext) -> [GroupRecord] {
        let fetchDescriptor = FetchDescriptor<GroupRecord>()
        
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Error fetching all groups: \(error)")
            return []
        }
    }

}
