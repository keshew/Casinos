import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button(action: { dismiss() }) {
            Image("backBtn")
                .resizable()
                .frame(width: 44, height: 44)
                .padding(12)
        }
    }
}

struct SettingsButton: View {
    @State private var showSettings = false
    var body: some View {
        Button(action: { showSettings = true }) {
            Image("settings")
                .resizable()
                .frame(width: 44, height: 44)
                .padding(12)
        }
        .fullScreenCover(isPresented: $showSettings) { SettingsView() }
    }
}


