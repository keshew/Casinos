import SwiftUI

@main
struct CasinosApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack { LoadingView() }
                .environmentObject(GameState())
        }
    }
}
