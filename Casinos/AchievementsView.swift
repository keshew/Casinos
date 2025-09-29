import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject private var game: GameState

    let gradients: [LinearGradient] = [
        LinearGradient(colors: [Color.red, Color.orange], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color.blue, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color.green, Color.yellow], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color.pink, Color.red], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color.teal, Color.cyan], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color.indigo, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color.orange, Color.red], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color.mint, Color.green], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color.purple, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color.yellow, Color.orange], startPoint: .topLeading, endPoint: .bottomTrailing)
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.0117, green: 0.0745, blue: 0.1608),
                    Color(red: 0.0117, green: 0.0745, blue: 0.1608),
                    Color(red: 0.0, green: 0.2, blue: 0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    BackButton()
                    Spacer()
                    Text("Achievements")
                        .font(.title).bold().foregroundColor(.white)
                    Spacer()
                    SettingsButton()
                        .disabled(true)
                        .hidden()
                }

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        ForEach(game.achievements.indices, id: \.self) { index in
                                   // Pick gradient based on index cyclically
                                   let gradient = gradients[index % gradients.count]

                                   Rectangle()
                                .fill(gradient.opacity(0.35))
                                       .overlay(
                                           RoundedRectangle(cornerRadius: 12)
                                               .stroke(gradient, lineWidth: 3)
                                               .overlay {
                                                   HStack {
                                                       Image(systemName: game.achievements[index].unlocked ? "rosette" : "lock.fill")
                                                           .foregroundColor(game.achievements[index].unlocked ? .yellow : .gray)
                                                           .font(.system(size: 20, weight: .bold))

                                                       Text(game.achievements[index].title)
                                                           .font(.system(size: 20, weight: .bold))
                                                           .foregroundColor(.white)
                                                       
                                                       Spacer()
                                                       
                                                       if game.achievements[index].unlocked {
                                                           Text("+\(game.achievements[index].rewardTickets) tickets")
                                                               .foregroundColor(.green)
                                                               .font(.system(size: 16, weight: .medium))
                                                       } else {
                                                           Text("Tickets: \(game.achievements[index].rewardTickets)")
                                                               .foregroundColor(.white.opacity(0.7))
                                                               .font(.system(size: 16, weight: .medium))
                                                       }
                                                   }
                                                   .padding(.horizontal)
                                               }
                                       )
                                       .frame(height: 80)
                                       .cornerRadius(12)
                               }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}


#Preview {
    AchievementsView()
        .environmentObject(GameState())
}
