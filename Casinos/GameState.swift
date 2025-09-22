import Foundation
import SwiftUI

@MainActor
final class GameState: ObservableObject {
    @Published var balance: Int = 10_000
    @Published var betPerLine: Int = 10
    @Published var lastWin: Int = 0
    @Published var isSpinning: Bool = false
    @Published var matrix: [[SlotSymbol]] = Array(repeating: Array(repeating: .s1, count: 3), count: 5)
    @Published var lineWins: [LineWin] = []
    @Published var jackpotWon: Bool = false
    @Published var tickets: Int = 0 // fictional tickets for store purchases
    @Published var achievements: [Achievement] = [
        Achievement(title: "First Spin", rewardTickets: 10, unlocked: false),
        Achievement(title: "Win 1,000", rewardTickets: 20, unlocked: false),
        Achievement(title: "Hit Jackpot", rewardTickets: 100, unlocked: false),
        Achievement(title: "Win 5,000", rewardTickets: 30, unlocked: false),
        Achievement(title: "Win 10,000", rewardTickets: 40, unlocked: false),
        Achievement(title: "Spin 50 times", rewardTickets: 50, unlocked: false),
        Achievement(title: "Spin 100 times", rewardTickets: 60, unlocked: false),
        Achievement(title: "5 line wins in one spin", rewardTickets: 80, unlocked: false),
        Achievement(title: "Balance 100,000", rewardTickets: 100, unlocked: false),
        Achievement(title: "Buy first item", rewardTickets: 15, unlocked: false)
    ]

    let paylines = Paylines20.all
    private let engine = SlotEngine()

    func spin() {
        guard !isSpinning else { return }
        let totalBet = betPerLine * paylines.count
        guard balance >= totalBet else { return }

        isSpinning = true
        balance -= totalBet
        lastWin = 0
        jackpotWon = false
        lineWins = []
        AudioManager.shared.play("spin")

        // Simulate spin delay
        Task { [weak self] in
            guard let self else { return }
            // animate by updating reels a few times
            for _ in 0..<15 {
                var rng: any RandomNumberGenerator = SystemRandomNumberGenerator()
                self.matrix = SlotSymbolFactory.randomMatrix(using: &rng)
                try? await Task.sleep(nanoseconds: 60_000_000) // 60ms per frame
            }
            // extra 2 seconds to prolong spinning
//            try? await Task.sleep(nanoseconds: 2_000_000_000)

            let result = engine.spin(betPerLine: betPerLine)
            self.matrix = result.matrix
            self.lineWins = result.lineWins
            self.lastWin = result.totalWin
            self.jackpotWon = result.jackpotWon
            self.balance += result.totalWin
            self.isSpinning = false
            AudioManager.shared.play("stop")
            if result.totalWin > 0 {
                AudioManager.shared.play("win")
            }
            if result.jackpotWon {
                AudioManager.shared.play("jackpot")
            }
            self.evaluateAchievements()
        }
    }

    func stop() {
        // Immediate resolve to final result
        guard isSpinning else { return }
        isSpinning = false
        let result = engine.spin(betPerLine: betPerLine)
        matrix = result.matrix
        lineWins = result.lineWins
        lastWin = result.totalWin
        jackpotWon = result.jackpotWon
        balance += result.totalWin
        AudioManager.shared.play("stop")
        if result.totalWin > 0 { AudioManager.shared.play("win") }
        if result.jackpotWon { AudioManager.shared.play("jackpot") }
        evaluateAchievements()
    }

    func increaseBet() { betPerLine = min(betPerLine + 5, 500) }
    func decreaseBet() { betPerLine = max(betPerLine - 5, 5) }

    // MARK: - Store (fictional currency)
    func buyBalance(amount: Int, priceTickets: Int) -> Bool {
        guard tickets >= priceTickets else { return false }
        tickets -= priceTickets
        balance += amount
        return true
    }

    func buyDoubleBet(spins: Int, priceTickets: Int) -> Bool {
        guard tickets >= priceTickets else { return false }
        tickets -= priceTickets
        // Simple effect: temporarily increase bet
        betPerLine = min(betPerLine * 2, 1_000)
        // In real impl, track spins-left; here we keep it simple
        return true
    }

    // MARK: - Achievements
    private func evaluateAchievements() {
        unlock(title: "First Spin", condition: true)
        unlock(title: "Win 1,000", condition: lastWin >= 1_000)
        unlock(title: "Hit Jackpot", condition: jackpotWon)
        unlock(title: "Win 5,000", condition: lastWin >= 5_000)
        unlock(title: "Win 10,000", condition: lastWin >= 10_000)
        // The following two require tracking total spins; simple approximation using tickets income is omitted
        // unlock(title: "Spin 50 times", condition: totalSpins >= 50)
        // unlock(title: "Spin 100 times", condition: totalSpins >= 100)
        unlock(title: "5 line wins in one spin", condition: lineWins.count >= 5)
        unlock(title: "Balance 100,000", condition: balance >= 100_000)
    }

    private func unlock(title: String, condition: Bool) {
        guard condition else { return }
        guard let idx = achievements.firstIndex(where: { $0.title == title }) else { return }
        guard achievements[idx].unlocked == false else { return }
        achievements[idx].unlocked = true
        tickets += achievements[idx].rewardTickets
    }
}


