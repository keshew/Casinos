import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var game: GameState
    @State private var showGame = false
    @State private var showStore = false
    @State private var showAchievements = false
    @State private var showSettings = false
    @State private var showWheel = false
    @ObservedObject var audio = AudioManager()
    
    var body: some View {
        ZStack {
                Color(red: 0.0117, green: 0.0745, blue: 0.1608) // #031329
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Название ")
                        .font(.largeTitle).bold().foregroundColor(.yellow)
                        .shadow(color: .yellow.opacity(0.6), radius: 10)
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        statCard(title: "Balance", value: "\(game.balance)", color: .yellow)
                        statCard(title: "Tickets", value: "\(game.tickets)", color: .mint)
                    }
                    
                    Spacer()
                    
                VStack(spacing: 12) {
                    Button { showGame = true } label: {
                        primaryButton(icon: "rectangle.grid.3x2.fill", text: "Slots", color: Color(red: 0.9294, green: 0.0863, blue: 0.1686))
                    }
                    .frame(height: 52)

                    Button { showWheel = true } label: {
                        primaryButton(icon: "dial.max.fill", text: "Wheel", color: Color(red: 0.9294, green: 0.0863, blue: 0.1686))
                    }
                    .frame(height: 52)

                    Button { showStore = true } label: {
                        primaryButton(icon: "cart.fill", text: "Shop", color: Color(red: 0.9294, green: 0.0863, blue: 0.1686))
                    }
                    .frame(height: 52)

                    Button { showAchievements = true } label: {
                        primaryButton(icon: "rosette", text: "Achievements", color: Color(red: 0.9294, green: 0.0863, blue: 0.1686))
                    }
                    .frame(height: 52)
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
    
    func primaryButton(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
            Text(text).bold()
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(RoundedRectangle(cornerRadius: 14).fill(color))
        .shadow(color: color.opacity(0.5), radius: 10, x: 0, y: 4)
    }


#Preview {
    HomeView()
        .environmentObject(GameState())
}
