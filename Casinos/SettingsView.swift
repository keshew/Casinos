import SwiftUI

struct SettingsView: View {
    @AppStorage("hapticsOn") private var hapticsOn = false
    @AppStorage("animationsOn") private var animationsOn = false
    @AppStorage("showPaylines") private var showPaylines = false
    @AppStorage("isMuted") private var isMuted = false
    @ObservedObject private var audioManager = AudioManager.shared

    var body: some View {
        ZStack {
            Color(red: 0.0117, green: 0.0745, blue: 0.1608)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    BackButton()
                    Spacer()
                    
                    Text("Settings")
                        .font(.title).bold().foregroundColor(.white)
                    
                    BackButton()
                        .hidden()
                        .disabled(true)
                    
                    Spacer()
                }

                List {
                    Section(header: Text("Audio").foregroundColor(.white)) {
                        Toggle("Mute sound", isOn: Binding(
                            get: { isMuted },
                            set: { newValue in
                                isMuted = newValue
                                AudioManager.shared.isMusicEnabled = !newValue
                                if newValue {
                                    AudioManager.shared.stopBackgroundMusic()
                                } else {
                                    AudioManager.shared.playBackgroundMusic()
                                }
                            }
                        ))
                        .tint(Color(red: 4/255, green: 19/255, blue: 119/255))
                        .foregroundColor(.white)
                    }
                    .listRowBackground(Color.white.opacity(0.05))

                    Section(header: Text("Haptics").foregroundColor(.white)) {
                        Toggle("Haptics", isOn: $hapticsOn)
                            .tint(Color(red: 4/255, green: 19/255, blue: 119/255))
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.white.opacity(0.05))

                    Section(header: Text("Gameplay").foregroundColor(.white)) {
                        Toggle("Animations", isOn: $animationsOn)
                            .tint(Color(red: 4/255, green: 19/255, blue: 119/255))
                            .foregroundColor(.white)
                        Toggle("Show paylines", isOn: $showPaylines)
                            .tint(Color(red: 4/255, green: 19/255, blue: 119/255))
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.white.opacity(0.05))
                }
                .scrollContentBackground(.hidden)
            }
            .padding(.horizontal)
        }
    }
}


#Preview {
    SettingsView()
        .environmentObject(GameState())
}
