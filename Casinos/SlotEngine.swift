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
        var matrix = SlotSymbolFactory.randomMatrix(using: &localRng)

        // Гарантируем выигрыш в примерно 40% спинов
        if Int.random(in: 0..<100, using: &localRng) < 40 {
            // Сделаем выигрышную линию: например, первая линия всегда с одинаковыми символами
            let winSymbol: SlotSymbol = .s1
            let payline = paylines[0]
            for reel in 0..<5 {
                matrix[reel][payline.rows[reel]] = winSymbol
            }
        }

        rng = localRng as! SystemRandomNumberGenerator

        let eval = evaluate(matrix: matrix, betPerLine: betPerLine)
        return eval
    }

    func evaluate(matrix: [[SlotSymbol]], betPerLine: Int) -> SpinResult {
        var wins: [LineWin] = []
        var jackpotWon = false

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

            // тут можно снизить порог выигрыша до 2 символов, чтобы выигрышей было больше
            if count >= 2, let mult = payoutTable.multiplier(for: firstSymbol, count: count) {
                let increasedMult = mult * 2 // или другой множитель для увеличения выигрыша
                let amount = increasedMult * betPerLine
                wins.append(LineWin(payline: line, symbol: firstSymbol, count: count, amount: amount))
            }
        }

        let middleRowSymbols = (0..<5).map { matrix[$0][1] }
        if Set(middleRowSymbols).isSubset(of: jackpot.requiredSymbols) {
            jackpotWon = true
        }

        let totalLineWin = wins.reduce(0) { $0 + $1.amount }
        let totalWin = totalLineWin * (jackpotWon ? jackpot.multiplier : 1)

        return SpinResult(matrix: matrix, lineWins: wins, totalWin: totalWin, jackpotWon: jackpotWon)
    }
}


