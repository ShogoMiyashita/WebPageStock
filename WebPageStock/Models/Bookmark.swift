import Foundation
import SwiftData

@Model
final class Bookmark {
    var id: UUID
    var url: String
    var title: String
    var memo: String
    var createdAt: Date
    var updatedAt: Date

    init(url: String, title: String, memo: String = "", createdAt: Date = .now, updatedAt: Date = .now) {
        self.id = UUID()
        self.url = url
        self.title = title
        self.memo = memo
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
