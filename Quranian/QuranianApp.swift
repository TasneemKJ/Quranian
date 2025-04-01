//
//  QuranianApp.swift
//  Quranian
//
//  Created by Tasnim Almousa on 01/04/2025.
//

import SwiftUI

@main
struct QuranReaderApp: App {
    var body: some Scene {
        WindowGroup {
            SurahListView()
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
