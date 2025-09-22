import Foundation

/// Represents a payline across a 5x3 grid as row indices per reel (0..2)
struct Payline: Identifiable, Hashable {
    let id: Int
    let rows: [Int] // length 5

    init(id: Int, rows: [Int]) {
        precondition(rows.count == 5, "Payline must have 5 positions")
        precondition(rows.allSatisfy { (0...2).contains($0) }, "Row indices must be 0..2")
        self.id = id
        self.rows = rows
    }
}

enum Paylines20 {
    /// 20 mixed lines: horizontals, diagonals, zig-zags
    static let all: [Payline] = [
        Payline(id: 1, rows: [0,0,0,0,0]),
        Payline(id: 2, rows: [1,1,1,1,1]),
        Payline(id: 3, rows: [2,2,2,2,2]),
        Payline(id: 4, rows: [0,1,2,1,0]),
        Payline(id: 5, rows: [2,1,0,1,2]),
        Payline(id: 6, rows: [0,0,1,0,0]),
        Payline(id: 7, rows: [2,2,1,2,2]),
        Payline(id: 8, rows: [1,0,1,2,1]),
        Payline(id: 9, rows: [1,2,1,0,1]),
        Payline(id: 10, rows: [0,1,1,1,2]),
        Payline(id: 11, rows: [2,1,1,1,0]),
        Payline(id: 12, rows: [0,1,0,1,0]),
        Payline(id: 13, rows: [2,1,2,1,2]),
        Payline(id: 14, rows: [0,2,1,2,0]),
        Payline(id: 15, rows: [2,0,1,0,2]),
        Payline(id: 16, rows: [0,0,2,0,0]),
        Payline(id: 17, rows: [2,2,0,2,2]),
        Payline(id: 18, rows: [1,1,0,1,1]),
        Payline(id: 19, rows: [1,1,2,1,1]),
        Payline(id: 20, rows: [0,2,0,2,0])
    ]
}


