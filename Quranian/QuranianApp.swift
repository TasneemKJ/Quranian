import SwiftUI

@main
struct QuranianApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                QuranPagerRootView()
                    .tabItem {
                        Label("السور", systemImage: "book")
                    }
                AthkarView()
                    .tabItem {
                        Label("أذكار", systemImage: "sparkles")
                    }
                Tasbee7View()
                    .tabItem {
                        Label("تسبيح", systemImage: "hands.sparkles")
                    }
            }
        }
    }
}
