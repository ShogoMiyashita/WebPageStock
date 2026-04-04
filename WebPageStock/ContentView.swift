import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var urlToOpen: String?

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("ブックマーク", systemImage: "book", value: 0) {
                BookmarkListView(urlToOpen: $urlToOpen, selectedTab: $selectedTab)
            }
            Tab("ブラウザ", systemImage: "globe", value: 1) {
                BrowserView(urlToOpen: $urlToOpen)
            }
        }
    }
}
