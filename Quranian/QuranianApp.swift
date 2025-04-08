import SwiftUI

@main
struct QuranianApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                QuranPagerView()
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
                SupportView()
                    .tabItem {
                        Label("ادعم", systemImage: "heart")
                    }
            }.environment(\.layoutDirection, .rightToLeft)
        }
    }
}
