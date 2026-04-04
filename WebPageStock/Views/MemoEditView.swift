import SwiftUI
import SwiftData

struct MemoEditView: View {
    @Bindable var bookmark: Bookmark
    @Environment(\.dismiss) private var dismiss
    @State private var memoText: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                Text(bookmark.title.isEmpty ? bookmark.url : bookmark.title)
                    .font(.headline)
                    .lineLimit(2)
                    .padding(.horizontal)

                TextEditor(text: $memoText)
                    .padding()
            }
            .navigationTitle("メモ編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        bookmark.memo = memoText
                        bookmark.updatedAt = .now
                        dismiss()
                    }
                }
            }
            .onAppear {
                memoText = bookmark.memo
            }
        }
    }
}
