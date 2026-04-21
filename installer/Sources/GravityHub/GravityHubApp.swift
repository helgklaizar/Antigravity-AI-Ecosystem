import SwiftUI

@main
struct GravityHubApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .frame(width: 560, height: 460)
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}
