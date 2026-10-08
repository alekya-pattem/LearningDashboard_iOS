import SwiftUI
import CoreData

@main
struct LearningDashboardApp: App {
    let persistenceController = CoreDataStack.shared
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, persistenceController.context)
        }
    }
}
