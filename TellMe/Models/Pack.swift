import Foundation

struct Pack: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let isFree: Bool
    let isLocked: Bool
    let dailyFreeLimit: Int?
    let sortOrder: Int
}

