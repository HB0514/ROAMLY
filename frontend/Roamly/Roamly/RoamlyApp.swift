import SwiftUI

@main
struct RoamlyApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            MainTabView()      // ✅ 여기!
                .environmentObject(appState)
        }
    }
}
