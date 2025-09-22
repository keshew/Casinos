import Foundation

struct Achievement: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let rewardTickets: Int
    var unlocked: Bool
}


