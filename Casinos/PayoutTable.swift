import Foundation

/// Simple payout table: matches of 3,4,5 of a kind along an active payline.
/// Values are multipliers against current bet per line.
struct PayoutTable {
    /// Multipliers for symbol rawValue: {3: x, 4: y, 5: z}
    let data: [Int: [Int: Int]]

    static func `default`() -> PayoutTable {
        var table: [Int: [Int: Int]] = [:]
        // Higher rawValue = rarer/more valuable (example). Adjust as needed.
        for symbol in SlotSymbol.allCases {
            let base = 2 + symbol.rawValue / 2
            table[symbol.rawValue] = [
                3: base,
                4: base * 4,
                5: base * 10
            ]
        }
        return PayoutTable(data: table)
    }

    func multiplier(for symbol: SlotSymbol, count: Int) -> Int? {
        data[symbol.rawValue]?[count]
    }
}

/// Jackpot rule definition
struct JackpotRule {
    let requiredSymbols: Set<SlotSymbol>
    let multiplier: Int
}


