import Foundation

struct SpinResult {
    let matrix: [[SlotSymbol]] // 5 x 3, columns as reels
    let lineWins: [LineWin]
    let totalWin: Int
    let jackpotWon: Bool
}

struct LineWin: Identifiable {
    let id = UUID()
    let payline: Payline
    let symbol: SlotSymbol
    let count: Int
    let amount: Int
}

final class SlotEngine {
    private var rng = SystemRandomNumberGenerator()
    private let payoutTable: PayoutTable
    private let paylines: [Payline]
    private let jackpot: JackpotRule

    init(payoutTable: PayoutTable = .default(), paylines: [Payline] = Paylines20.all, jackpot: JackpotRule = JackpotRule(requiredSymbols: [.s15, .s16], multiplier: 500)) {
        self.payoutTable = payoutTable
        self.paylines = paylines
        self.jackpot = jackpot
    }

    func spin(betPerLine: Int) -> SpinResult {
        var localRng: any RandomNumberGenerator = rng
        let matrix = SlotSymbolFactory.randomMatrix(using: &localRng)
        rng = localRng as! SystemRandomNumberGenerator

        let eval = evaluate(matrix: matrix, betPerLine: betPerLine)
        return eval
    }

    func evaluate(matrix: [[SlotSymbol]], betPerLine: Int) -> SpinResult {
        var wins: [LineWin] = []
        var jackpotWon = false

        // Line evaluation: left to right, count consecutive identical symbols starting at reel 0 position of the payline.
        for line in paylines {
            let firstSymbol = matrix[0][line.rows[0]]
            var count = 1
            for reel in 1..<5 {
                if matrix[reel][line.rows[reel]] == firstSymbol {
                    count += 1
                } else {
                    break
                }
            }
            if count >= 3, let mult = payoutTable.multiplier(for: firstSymbol, count: count) {
                let amount = mult * betPerLine
                wins.append(LineWin(payline: line, symbol: firstSymbol, count: count, amount: amount))
            }
        }

        // Jackpot: if any row across reels shows only required symbols (in any order) on the same line, award jackpot
        // Here we define a simple rule: middle row (row 1) all symbols belong to required set -> jackpot
        let middleRowSymbols = (0..<5).map { matrix[$0][1] }
        if Set(middleRowSymbols).isSubset(of: jackpot.requiredSymbols) {
            jackpotWon = true
        }

        let totalLineWin = wins.reduce(0) { $0 + $1.amount }
        let totalWin = totalLineWin * (jackpotWon ? jackpot.multiplier : 1)

        return SpinResult(matrix: matrix, lineWins: wins, totalWin: totalWin, jackpotWon: jackpotWon)
    }
}


