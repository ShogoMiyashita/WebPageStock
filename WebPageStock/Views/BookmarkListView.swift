import SwiftUI
import SwiftData

struct BookmarkListView: View {
    @Binding var urlToOpen: String?
    @Binding var selectedTab: Int
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Bookmark.createdAt, order: .reverse) private var bookmarks: [Bookmark]
    @State private var selectedBookmark: Bookmark?

    var body: some View {
        NavigationStack {
            Group {
                if bookmarks.isEmpty {
                    ContentUnavailableView(
                        "ブックマークはまだありません",
                        systemImage: "bookmark",
                        description: Text("ブラウザでページを閲覧し、保存ボタンをタップして追加しましょう")
                    )
                } else {
                    List {
                        ForEach(bookmarks) { bookmark in
                            BookmarkRow(bookmark: bookmark)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    urlToOpen = bookmark.url
                                    selectedTab = 1
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        modelContext.delete(bookmark)
                                    } label: {
                                        Label("削除", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        selectedBookmark = bookmark
                                    } label: {
                                        Label("メモ", systemImage: "note.text")
                                    }
                                    .tint(.orange)
                                }
                        }
                    }
                }
            }
            .navigationTitle("ブックマーク")
            .sheet(item: $selectedBookmark) { bookmark in
                MemoEditView(bookmark: bookmark)
            }
        }
    }
}

struct BookmarkRow: View {
    let bookmark: Bookmark

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(bookmark.title.isEmpty ? bookmark.url : bookmark.title)
                .font(.headline)
                .lineLimit(1)

            Text(bookmark.url)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            HStack {
                Text(bookmark.createdAt, style: .date)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)

                if !bookmark.memo.isEmpty {
                    Spacer()
                    HStack(spacing: 2) {
                        Image(systemName: "note.text")
                            .font(.caption2)
                        Text(bookmark.memo)
                            .font(.caption2)
                            .lineLimit(1)
                    }
                    .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 2)
    }
}
