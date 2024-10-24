import SwiftUI
import SwiftData

@main
struct High_TenseApp: App {	
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
				.modelContainer(for: [TaskModel.self])
    }
}
