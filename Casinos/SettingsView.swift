import SwiftUI

struct SettingsView: View {
    @State private var hapticsOn: Bool = true
    @State private var animationsOn: Bool = true
    @State private var showPaylines: Bool = true
    @State private var isMuted: Bool = AudioManager.shared.isMuted

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
                            set: { isMuted = $0; AudioManager.shared.isMuted = $0 }
                        ))
                        .tint(.white)
                        .foregroundColor(.white)
                    }
                    .listRowBackground(Color.white.opacity(0.05))

                    Section(header: Text("Haptics").foregroundColor(.white)) {
                        Toggle("Haptics", isOn: $hapticsOn)
                            .tint(.white)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.white.opacity(0.05))

                    Section(header: Text("Gameplay").foregroundColor(.white)) {
                        Toggle("Animations", isOn: $animationsOn)
                            .tint(.white)
                            .foregroundColor(.white)
                        Toggle("Show paylines", isOn: $showPaylines)
                            .tint(.white)
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
