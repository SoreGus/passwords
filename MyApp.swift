import SwiftUI
import SwiftData

@main
struct SecureStorageApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([PasswordRecord.self])
        let container = try! ModelContainer(for: schema)
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
        }
    }
}
