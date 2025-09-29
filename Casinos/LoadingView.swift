import SwiftUI

struct LoadingView: View {
    @State private var progress: CGFloat = 0
    @State private var navigate: Bool = false

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
                Image("logoCasino")
                    .resizable()
                    .frame(width: 227, height: 72)

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 0.0549, green: 0.1529, blue: 0.2863)) // #0E2749
                        .frame(width: 247, height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 0.9294, green: 0.0902, blue: 0.1686)) // #ED172B
                        .frame(width: 247 * progress, height: 8)
                        .animation(.linear(duration: 1.2), value: progress)
                }
            }
        }
        .onAppear {
            // simple staged progress
            Task {
                for step in 1...12 {
                    try? await Task.sleep(nanoseconds: 120_000_000)
                    progress = CGFloat(step) / 12.0
                }
                navigate = true
            }
        }
        .fullScreenCover(isPresented: $navigate) { HomeView() }
    }
}

#Preview {
    LoadingView()
            .environmentObject(GameState())
}
