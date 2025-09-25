import Foundation

struct Achievement: Identifiable, Hashable, Codable {
    var id = UUID().uuidString
    let title: String
    let rewardTickets: Int
    var unlocked: Bool
}


