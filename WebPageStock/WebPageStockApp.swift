import SwiftUI
import SwiftData

@main
struct WebPageStockApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Bookmark.self)
    }
}
