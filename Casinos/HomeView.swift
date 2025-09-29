import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var game: GameState
    @State private var showGame = false
    @State private var showStore = false
    @State private var showAchievements = false
    @State private var showSettings = false
    @State private var showWheel = false
    @ObservedObject var audio = AudioManager()
    @State private var showPlink = false
    @State private var dailyRewardClaimed = false
    @AppStorage("lastDailyRewardDate") private var lastDailyRewardDate: Date = .distantPast
    
    let buttonGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 48/255, green: 25/255, blue: 52/255),
            Color(red: 94/255, green: 44/255, blue: 102/255)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    
@State private var timeRemaining: TimeInterval = 0
let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func updateTimeRemaining() {
        if dailyRewardAvailable {
            timeRemaining = 0
        } else {
            let nextRewardDate = lastDailyRewardDate.addingTimeInterval(24 * 60 * 60)
            timeRemaining = max(0, nextRewardDate.timeIntervalSince(Date()))
        }
    }

    
    func formatTime(_ time: TimeInterval) -> String {
         let totalSeconds = Int(time)
         let hours = totalSeconds / 3600
         let minutes = (totalSeconds % 3600) / 60
         let seconds = totalSeconds % 60
         if hours > 0 {
             return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
         } else {
             return String(format: "%02d:%02d", minutes, seconds)
         }
     }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 3/255, green: 19/255, blue: 41/255),
                    Color(red: 3/255, green: 19/255, blue: 41/255),
                    Color(red: 40/255, green: 10/255, blue: 70/255)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                let dailyRewardAvailable = !Calendar.current.isDateInToday(lastDailyRewardDate)
                       let buttonText = dailyRewardAvailable ? "Daily Reward" : "Claimed \(formatTime(timeRemaining))"
                
                Text("Win Slots Casino")
                    .font(.title).bold().foregroundColor(.yellow)
                    .shadow(color: .yellow.opacity(0.6), radius: 10)
                
                Spacer()
                
                HStack(spacing: 12) {
                    statCard(title: "Balance", value: "\(game.balance)", color: .yellow)
                    statCard(title: "Tickets", value: "\(game.tickets)", color: .white)
                }
                
                Spacer()
                
                VStack(spacing: 15) {
                    Button { showGame = true } label: {
                        primaryButton(icon: "rectangle.grid.3x2.fill", text: "Slots", gradient: buttonGradient)
                    }
                    .frame(height: 52)
                    
                    Button { showPlink = true } label: {
                        primaryButton(icon: "circle.hexagongrid.circle", text: "Ball", gradient: buttonGradient)
                    }
                    .frame(height: 52)
                    
                    Button { showWheel = true } label: {
                        primaryButton(icon: "dial.max.fill", text: "Wheel", gradient: buttonGradient)
                    }
                    .frame(height: 52)
                    
                    Button { showStore = true } label: {
                        primaryButton(icon: "cart.fill", text: "Shop", gradient: buttonGradient)
                    }
                    .frame(height: 52)
                    
                    Button { showAchievements = true } label: {
                        primaryButton(icon: "rosette", text: "Achievements", gradient: buttonGradient)
                    }
                    .frame(height: 52)
                    
                    Button {
                              claimDailyReward()
                          } label: {
                              primaryButton(icon: "gift.fill", text: buttonText, gradient: buttonGradient)
                          }
                          .frame(height: 52)
                          .disabled(!dailyRewardAvailable)
                          .onReceive(timer) { _ in
                              updateTimeRemaining()
                          }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                Spacer()
            }
            .padding()
            .overlay(alignment: .topTrailing) {
                Button { showSettings = true } label: {
                    Image("settings")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .padding(12)
                }
            }
        }
        .fullScreenCover(isPresented: $showGame) { ContentView() }
        .fullScreenCover(isPresented: $showStore) { StoreView() }
        .fullScreenCover(isPresented: $showAchievements) { AchievementsView() }
        .fullScreenCover(isPresented: $showSettings) { SettingsView() }
        .fullScreenCover(isPresented: $showWheel) { WheelView() }
        .fullScreenCover(isPresented: $showPlink) { BrickGameView(level: 2) }
    }
    
    var dailyRewardAvailable: Bool {
        !Calendar.current.isDateInToday(lastDailyRewardDate)
    }

    // Claim daily reward
    func claimDailyReward() {
        guard dailyRewardAvailable else { return }
        game.balance += 1000
        lastDailyRewardDate = Date()
    }
}



func statCard(title: String, value: String, color: Color) -> some View {
    Rectangle()
        .fill(.clear)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white, lineWidth: 2)
                .overlay {
                    VStack(spacing: 4) {
                        Text(title).font(.caption).foregroundColor(.white.opacity(0.8))
                        Text(value).font(.headline).bold().foregroundColor(color)
                    }
                }
        }
        .frame(width: 120, height: 57)
        .cornerRadius(16)
}

func primaryButton(icon: String, text: String, gradient: LinearGradient) -> some View {
    HStack(spacing: 10) {
        Image(systemName: icon)
        Text(text).bold()
    }
    .foregroundColor(.white)
    .padding()
    .frame(maxWidth: .infinity)
    .background(
        RoundedRectangle(cornerRadius: 14)
            .fill(gradient.opacity(0.7))
    )
    .overlay(
        RoundedRectangle(cornerRadius: 14)
            .stroke(.white, lineWidth: 0.5)  // Градиентная обводка
    )
    .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 3)
}




#Preview {
    HomeView()
        .environmentObject(GameState())
}
