import SwiftUI

struct StoreView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var game: GameState
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                BackButton()
                Spacer()
                Text("Store")
                    .font(.title).bold().foregroundColor(.white)
                Spacer()
                SettingsButton()
            }
//            .padding(.top)

            storeItems

            Spacer()
        }
        .padding(.horizontal)
        .background(Color(red: 0.0117, green: 0.0745, blue: 0.1608).ignoresSafeArea())
    }

    var storeItems: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Tickets: \(game.tickets)").foregroundColor(.white)
                Spacer()
            }
            StoreItemRow(title: "+5,000 Balance", price: "20 tickets") { _ = game.buyBalance(amount: 5_000, priceTickets: 20) }
            StoreItemRow(title: "+20,000 Balance", price: "60 tickets") { _ = game.buyBalance(amount: 20_000, priceTickets: 60) }
            StoreItemRow(title: "Double Bet", price: "40 tickets") { _ = game.buyDoubleBet(spins: 10, priceTickets: 40) }
            StoreItemRow(title: "Jackpot Boost", price: "50 tickets") { /* Placeholder: could bias engine */ }
        }
    }
}

private struct StoreItemRow: View {
    let title: String
    let price: String
    let action: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title).foregroundColor(.white).bold()
                Text("One-time purchase").foregroundColor(.white.opacity(0.7)).font(.caption)
            }
            Spacer()
            Button(action: action) {
                Text(price)
                    .foregroundColor(.black)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.yellow))
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.08)))
    }
}


#Preview {
    StoreView()
        .environmentObject(GameState())
}
