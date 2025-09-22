//
//  CasinosApp.swift
//  Casinos
//
//  Created by Артём Коротков on 22.09.2025.
//

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
