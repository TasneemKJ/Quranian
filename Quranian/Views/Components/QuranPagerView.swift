//
//  QuranPagerView.swift
//  Quranian
//
//  Created by Tasnim Almousa on 07/04/2025.
//

import SwiftUI

struct QuranPagerView: View {
    @StateObject private var manager = QuranPageManager(verses: QuranDataManager.loadFromJSON())
    @AppStorage("lastQuranPage") private var selectedPage: Int = 1
    @State private var showSurahPicker = false

    private let surahList = QuranDataManager.getSurahList()

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    showSurahPicker = true
                }) {
                    Label("السور", systemImage: "list.bullet")
                        .labelStyle(.titleOnly)
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Capsule())
                }
                .font(.headline)
                .padding(.leading, 16)
                .padding(.top, 12)
                Spacer()
            }

            // 📖 Main Quran Pages
            TabView(selection: $selectedPage) {
                ForEach(1...manager.totalPages, id: \.self) { page in
                    if let verses = manager.getPage(page) {
                        QuranPageView(pageNumber: page, verses: verses)
                            .tag(page)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: selectedPage)
        }
        .sheet(isPresented: $showSurahPicker) {
            SurahListView(surahs: surahList) { selectedSurah in
                selectedPage = selectedSurah.page
                showSurahPicker = false
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}
