import SwiftUI

/// Represents one of the 16 slot symbols backed by assets named "1slot" ... "16slot".
enum SlotSymbol: Int, CaseIterable, Identifiable {
    case s1 = 1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16

    var id: Int { rawValue }

    var imageName: String { "\(rawValue)slot" }

    var image: Image { Image(imageName) }
}

/// Convenience to produce random symbols and reels.
enum SlotSymbolFactory {
    static func randomSymbol(using rng: inout RandomNumberGenerator) -> SlotSymbol {
        let index = Int.random(in: 0..<SlotSymbol.allCases.count, using: &rng)
        return SlotSymbol.allCases[index]
    }

    /// Returns a column (reel) of 3 symbols.
    static func randomReel(using rng: inout RandomNumberGenerator) -> [SlotSymbol] {
        return (0..<3).map { _ in randomSymbol(using: &rng) }
    }

    /// Returns a matrix of size 5 x 3 (reels x rows)
    static func randomMatrix(using rng: inout RandomNumberGenerator) -> [[SlotSymbol]] {
        return (0..<5).map { _ in randomReel(using: &rng) }
    }
}


