import SwiftUI

struct StoreView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var game: GameState

    @State private var showAlert = false
    @State private var alertMessage = ""

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

            storeItems

            Spacer()
        }
        .padding(.horizontal)
        .background(      LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 23/255, green: 29/255, blue: 41/255),
                Color(red: 3/255, green: 19/255, blue: 41/255),
                Color(red: 40/255, green: 50/255, blue: 70/255)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea())
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
    }

    var storeItems: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Tickets: \(game.tickets)").foregroundColor(.white)
                Spacer()
            }
            StoreItemRow(title: "+5,000 Balance", price: "20 tickets") {
                let success = game.buyBalance(amount: 5_000, priceTickets: 20)
                if success {
                    alertMessage = "You have successfully purchased +5,000 Balance!"
                } else {
                    alertMessage = "You do not have enough tickets to make this purchase."
                }
                showAlert = true
            }
            StoreItemRow(title: "+20,000 Balance", price: "60 tickets") {
                let success = game.buyBalance(amount: 20_000, priceTickets: 60)
                if success {
                    alertMessage = "You have successfully purchased +20,000 Balance!"
                } else {
                    alertMessage = "You do not have enough tickets to make this purchase."
                }
                showAlert = true
            }
            StoreItemRow(title: "Double Bet", price: "40 tickets") {
                let success = game.buyDoubleBet(spins: 10, priceTickets: 40)
                if success {
                    alertMessage = "You have successfully purchased Double Bet (10 spins)!"
                } else {
                    alertMessage = "You do not have enough tickets to make this purchase."
                }
                showAlert = true
            }
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
