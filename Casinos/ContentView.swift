import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var game: GameState
    @State private var isMuted: Bool = false
    @Namespace private var reelNamespace

    var body: some View {
        ZStack {
            Color(red: 0.0117, green: 0.0745, blue: 0.1608)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                header
                    .padding(.horizontal, UIScreen.main.bounds.size.width > 900 ? 290 : UIScreen.main.bounds.size.width > 700 ? 160 : 0)
                cabinet
                controlsBar
                footer
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .overlay(alignment: .topLeading) { BackButton().padding(.top, 4) }
        .overlay(alignment: .topTrailing) { SettingsButton().padding(.top, 4) }
    }
}

#Preview {
    ContentView()
            .environmentObject(GameState())
}

private extension ContentView {
    var header: some View {
        HStack(spacing: 12) {
            statCard(title: "Balance", value: "\(game.balance)", color: .yellow)
            statCard(title: "Bet/line", value: "\(game.betPerLine)", color: .cyan)
            statCard(title: "Lines", value: "\(game.paylines.count)", color: .orange)
            Spacer(minLength: 0)
            Button(action: {
                isMuted.toggle()
                AudioManager.shared.isMusicEnabled = !isMuted
                if isMuted {
                    AudioManager.shared.stopBackgroundMusic()
                } else {
                    AudioManager.shared.playBackgroundMusic()
                }
            }) {
                Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white.opacity(0.12))
                    .clipShape(Circle())
            }
            .disabled(true)
            .hidden()
        }
    }

    func statCard(title: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundColor(.white.opacity(0.8))
            Text(value).font(.headline).bold().foregroundColor(color)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.08)))
    }

    var cabinet: some View {
        GeometryReader { geo in
            let cabinetWidth = min(geo.size.width, 420)
            let cabinetHeight = cabinetWidth * 0.62
            VStack(spacing: 0) {
                reelsGrid(width: cabinetWidth, height: cabinetHeight)
            }
            .frame(width: cabinetWidth, height: cabinetHeight)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(LinearGradient(colors: [Color.white.opacity(0.06), Color.white.opacity(0.02)], startPoint: .top, endPoint: .bottom))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.5), radius: 14, x: 0, y: 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(height: 320)
    }

    func reelsGrid(width: CGFloat, height: CGFloat) -> some View {
        let innerPadding: CGFloat = 10
        let contentWidth = width - innerPadding * 2
        let contentHeight = height - innerPadding * 2
        let tileSpacing: CGFloat = 8
        let reelWidth = (contentWidth - tileSpacing * 4) / 5
        let tileHeight = (contentHeight - tileSpacing * 2) / 3

        return HStack(spacing: tileSpacing) {
            ForEach(0..<5, id: \.self) { reel in
                VStack(spacing: tileSpacing) {
                    ForEach(0..<3, id: \.self) { row in
                        let symbol = game.matrix[reel][row]
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.08))
                                .overlay(
                                    LinearGradient(colors: [Color.white.opacity(0.10), Color.clear], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.35), radius: 6, x: 0, y: 3)

                            symbol.image
                                .resizable()
                                .scaledToFit()
                                .padding(6)
                        }
                        .frame(width: reelWidth, height: tileHeight)
                        .transition(.opacity.combined(with: .scale))
                        .animation(.easeOut(duration: 0.09), value: game.matrix)
                    }
                }
            }
        }
        .padding(innerPadding)
    }

    var controlsBar: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                Button(action: game.decreaseBet) {
                    largePill(icon: "minus.circle.fill", text: "Bet")
                }
                Button(action: game.increaseBet) {
                    largePill(icon: "plus.circle.fill", text: "Bet")
                }
            }
            HStack {
                Spacer()
                if game.isSpinning {
                    Button(action: game.stop) {
                        primaryButton(icon: "stop.fill", text: "Stop", color: .red)
                            .foregroundColor(.white)
                    }
                    .disabled(!game.isSpinning)
                } else {
                    Button(action: game.spin) {
                        primaryButton(icon: "play.fill", text: "SPIN", color: .green)
                    }
                    .disabled(game.balance < game.betPerLine * game.paylines.count)
                }
                Spacer()
            }
        }
    }

    var footer: some View {
        VStack(spacing: 8) {
            if game.jackpotWon {
                Text("JACKPOT!")
                    .font(.title).bold().foregroundColor(.red)
                    .shadow(color: .red.opacity(0.6), radius: 8)
                    .transition(.scale)
            }
            if game.lastWin > 0 {
                Text("Win: \(game.lastWin)")
                    .font(.headline).bold().foregroundColor(.green)
            }
            if !game.lineWins.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(game.lineWins) { win in
                            Text("Line #\(win.payline.id): x\(win.count) \(win.symbol.rawValue)slot = +\(win.amount)")
                                .padding(8)
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.08)))
                        }
                    }
                }
                .frame(height: 40)
            }
        }
    }

    func pill(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text)
        }
        .foregroundColor(.white)
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.12)))
    }

    func largePill(icon: String, text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
            Text(text)
                .font(.headline)
        }
        .foregroundColor(.white)
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.15)))
    }

    func primaryButton(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
            Text(text).bold()
        }
        .foregroundColor(.black)
        .padding(.vertical, 12)
        .padding(.horizontal, 18)
        .background(RoundedRectangle(cornerRadius: 14).fill(color))
        .shadow(color: color.opacity(0.6), radius: 10, x: 0, y: 4)
    }
}
