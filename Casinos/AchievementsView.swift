import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject private var game: GameState

    var body: some View {
        ZStack {
            Color(red: 0.0117, green: 0.0745, blue: 0.1608)
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

                List {
                    ForEach(game.achievements) { a in
                        HStack {
                            Image(systemName: a.unlocked ? "rosette" : "lock.fill")
                                .foregroundColor(a.unlocked ? .yellow : .gray)
                            Text(a.title)
                            Spacer()
                            if a.unlocked {
                                Text("+\(a.rewardTickets) tickets").foregroundColor(.green)
                            } else {
                                Text("Reward: \(a.rewardTickets)").foregroundColor(.white.opacity(0.7))
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.05))
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding(.horizontal)
        }
    }
}


#Preview {
    AchievementsView()
        .environmentObject(GameState())
}
