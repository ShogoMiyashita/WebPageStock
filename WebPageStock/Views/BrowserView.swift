import SwiftUI
import SwiftData

struct BrowserView: View {
    @Binding var urlToOpen: String?
    @Environment(\.modelContext) private var modelContext
    @Query private var bookmarks: [Bookmark]

    @State private var urlText = ""
    @State private var webViewURL: URL? = URL(string: "https://www.apple.com")
    @State private var currentURL = ""
    @State private var currentTitle = ""
    @State private var estimatedProgress = 0.0
    @State private var isLoading = false
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var navigationAction: NavigationAction = .none

    private var isBookmarked: Bool {
        bookmarks.contains { $0.url == currentURL }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("URLを入力または検索", text: $urlText)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.URL)
                    .onSubmit {
                        loadURL(urlText)
                    }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            if isLoading {
                ProgressView(value: estimatedProgress)
                    .progressViewStyle(.linear)
            }

            WebView(
                url: $webViewURL,
                currentURL: $currentURL,
                currentTitle: $currentTitle,
                estimatedProgress: $estimatedProgress,
                isLoading: $isLoading,
                canGoBack: $canGoBack,
                canGoForward: $canGoForward,
                navigationAction: $navigationAction
            )

            HStack(spacing: 40) {
                Button(action: { navigationAction = .goBack }) {
                    Image(systemName: "chevron.left")
                }
                .disabled(!canGoBack)

                Button(action: { navigationAction = .goForward }) {
                    Image(systemName: "chevron.right")
                }
                .disabled(!canGoForward)

                Button(action: { navigationAction = .reload }) {
                    Image(systemName: "arrow.clockwise")
                }

                Button(action: { toggleBookmark() }) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                }
                .disabled(currentURL.isEmpty)
            }
            .font(.title2)
            .padding()
        }
        .onChange(of: currentURL) { _, newValue in
            urlText = newValue
        }
        .onChange(of: urlToOpen) { _, newValue in
            if let urlString = newValue {
                loadURL(urlString)
                urlToOpen = nil
            }
        }
    }

    private func loadURL(_ input: String) {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if let url = URL(string: trimmed), url.scheme != nil, url.host != nil {
            webViewURL = url
        } else if let url = URL(string: "https://\(trimmed)"), trimmed.contains(".") {
            webViewURL = url
        } else {
            let query = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? trimmed
            webViewURL = URL(string: "https://www.google.com/search?q=\(query)")
        }
    }

    private func toggleBookmark() {
        if let existing = bookmarks.first(where: { $0.url == currentURL }) {
            modelContext.delete(existing)
        } else {
            let bookmark = Bookmark(url: currentURL, title: currentTitle)
            modelContext.insert(bookmark)
        }
    }
}
