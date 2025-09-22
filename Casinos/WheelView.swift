import SwiftUI

struct WheelView: View {
    @State private var angle: Double = 0
    @State private var isSpinning: Bool = false
    @State private var resultText: String = ""
    @State private var showWinOverlay: Bool = false
    @State private var prizeAmount: Int = 0
    @State private var spinsLeft: Int = 3
    private let maxSpins: Int = 5
    @State private var nextRefillDate: Date? = nil
    @State private var remainingSeconds: Int = 0
    @State private var timer: Timer? = nil

    var body: some View {
        ZStack {
            Color(red: 0.0117, green: 0.0745, blue: 0.1608)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                HStack {
                    BackButton()
                    Spacer()
                   
                    Rectangle()
                        .fill(.white)
                        .frame(width: 73, height: 26)
                        .overlay {
                            Text("\(spinsLeft) spins left").foregroundColor(Color(red: 0.0117, green: 0.0745, blue: 0.1608))
                                .font(.system(size: 11))
                        }
                        .cornerRadius(16)
                    Spacer()
                    SettingsButton()
                }

                Spacer()
                
                Text("Spin the Wheel").foregroundColor(.white).font(.system(size: 30, weight: .bold))
                if let _ = nextRefillDate {
                    Text("\(maxSpins) more spins ready in \(formattedTime(remainingSeconds))")
                        .foregroundColor(.white.opacity(0.8)).font(.system(size: 10, weight: .bold))
                }

                Spacer()

                ZStack(alignment: .top) {
                    Image("wheel")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 330)
                        .rotationEffect(.degrees(angle))
                        .animation(isSpinning ? .timingCurve(0.2, 0.8, 0.1, 1, duration: 2.2) : .default, value: angle)
                    
                    Image("pin")
                        .resizable()
                        .frame(width: 15, height: 40)
                        .offset(y: -00)
                }
                
                Spacer()
                
                Button(action: spin) {
                    LinearGradient(colors: [Color(red: 0.1294, green: 0.8, blue: 0.3176), Color(red: 0.0863, green: 0.4314, blue: 0.3333)], startPoint: .leading, endPoint: .trailing)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                .overlay {
                                    Text(isSpinning ? "Spinning..." : "Spin")
                                        .font(.headline).bold()
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                }
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(LinearGradient(colors: [Color(red: 0.1294, green: 0.8, blue: 0.3176), Color(red: 0.0863, green: 0.4314, blue: 0.3333)], startPoint: .leading, endPoint: .trailing))
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        .frame(width: 140, height: 50)
                }
                .disabled(isSpinning || spinsLeft <= 0)
                
                Spacer()
            }
            
            if showWinOverlay {
                Color.black.opacity(0.7).ignoresSafeArea()
                
                 Image(.win)
                    .resizable()
                    .overlay {
                        VStack {
                            Text("Claim \(prizeAmount)$")
                                .foregroundColor(.white).font(.system(size: 20, weight: .bold))
                                .padding(.top, 190)
                            
                            Button(action: { showWinOverlay = false }) {
                                LinearGradient(colors: [Color(red: 0.1294, green: 0.8, blue: 0.3176), Color(red: 0.0863, green: 0.4314, blue: 0.3333)], startPoint: .leading, endPoint: .trailing)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                            .overlay {
                                                Text("CLAIM")
                                                    .font(.headline).bold()
                                                    .frame(maxWidth: .infinity)
                                                    .padding(.vertical, 12)
                                            }
                                    )
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(LinearGradient(colors: [Color(red: 0.1294, green: 0.8, blue: 0.3176), Color(red: 0.0863, green: 0.4314, blue: 0.3333)], startPoint: .leading, endPoint: .trailing))
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                                    .frame(width: 140, height: 50)
                            }
                        }
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 327, height: 324)
            }
        }
        .onAppear { loadSpinsState(); startTimerIfNeeded() }
    }

    private func spin() {
        guard !isSpinning else { return }
        guard spinsLeft > 0 else { return }
        isSpinning = true
        resultText = ""
        spinsLeft -= 1
        saveSpinsState()
        let rounds = Double(Int.random(in: 4...7))
        let stopAt = Double(Int.random(in: 0..<360))
        let target = rounds * 360 + stopAt
        angle += target

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
            isSpinning = false
            let final = angle.truncatingRemainder(dividingBy: 360)
            resultText = "Result: \(Int(final))°"
            prizeAmount = prizeForAngle(final)
            showWinOverlay = true
            if spinsLeft == 0 && nextRefillDate == nil {
                nextRefillDate = Date().addingTimeInterval(23*3600 + 9*60 + 7)
                startTimerIfNeeded()
                saveSpinsState()
            }
        }
    }

    private func prizeForAngle(_ angle: Double) -> Int {
        let prizes = [100, 200, 300, 400, 500, 600, 700, 800]

        let normalized = (angle.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
        let adjusted = (normalized + 22.5).truncatingRemainder(dividingBy: 360)
        let originalIndex = Int(adjusted / 45.0) % prizes.count

        let correctedIndex = (prizes.count - originalIndex) % prizes.count

        return prizes[correctedIndex]
    }

    private func loadSpinsState() {
        let d = UserDefaults.standard
        if d.object(forKey: "wheel_spinsLeft") == nil {
            spinsLeft = 3
        } else {
            spinsLeft = d.integer(forKey: "wheel_spinsLeft")
        }
        if let t = d.object(forKey: "wheel_nextRefill") as? TimeInterval {
            nextRefillDate = Date(timeIntervalSince1970: t)
            updateRemainingSeconds()
        }
    }

    private func saveSpinsState() {
        let d = UserDefaults.standard
        d.set(spinsLeft, forKey: "wheel_spinsLeft")
        if let date = nextRefillDate {
            d.set(date.timeIntervalSince1970, forKey: "wheel_nextRefill")
        } else {
            d.removeObject(forKey: "wheel_nextRefill")
        }
    }

    private func startTimerIfNeeded() {
        timer?.invalidate()
        guard nextRefillDate != nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            updateRemainingSeconds()
        }
    }

    private func updateRemainingSeconds() {
        guard let date = nextRefillDate else { remainingSeconds = 0; return }
        let now = Date()
        let diff = Int(date.timeIntervalSince(now))
        if diff <= 0 {
            remainingSeconds = 0
            spinsLeft = maxSpins
            nextRefillDate = nil
            saveSpinsState()
            timer?.invalidate(); timer = nil
        } else {
            remainingSeconds = diff
        }
    }

    private func formattedTime(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}

#Preview {
    WheelView()
        .environmentObject(GameState())
}
