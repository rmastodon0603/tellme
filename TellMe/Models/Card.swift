import Foundation

struct Card: Identifiable, Codable {
    let id: String
    let packId: String
    let text: String
    let sortOrder: Int
}

