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
    @AppStorage("bookmarkedPages") private var bookmarkedPagesData: Data = Data()
    @State private var bookmarkedPages: [Int] = []

    @State private var showSurahPicker = false
    @State private var showBookmarks = false

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

                // 📖 Bookmarks menu
                Button(action: {
                    showBookmarks = true
                }) {
                    Image(systemName: "book")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
                .padding(.trailing, 8)
                .padding(.top, 12)

                // ⭐️ Bookmark toggle
                Button(action: {
                    toggleBookmark(for: selectedPage)
                }) {
                    Image(systemName: bookmarkedPages.contains(selectedPage) ? "bookmark.fill" : "bookmark")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
                .padding(.trailing, 16)
                .padding(.top, 12)
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
        .sheet(isPresented: $showBookmarks) {
            VStack {
                Text("⭐️ الصفحات المحفوظة")
                    .font(.headline)
                    .padding()

                if bookmarkedPages.isEmpty {
                    Text("لا يوجد صفحات محفوظة")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(bookmarkedPages.sorted(), id: \.self) { page in
                        Button("📖 الصفحة \(page)") {
                            selectedPage = page
                            showBookmarks = false
                        }
                    }.environment(\.layoutDirection, .rightToLeft)
                }
            }
            .presentationDetents([.medium])
            .environment(\.layoutDirection, .rightToLeft)
        }
        .onAppear {
            loadBookmarks()
        }
        .environment(\.layoutDirection, .rightToLeft)
    }

    // MARK: - Bookmarking Logic

    private func loadBookmarks() {
        if let decoded = try? JSONDecoder().decode([Int].self, from: bookmarkedPagesData) {
            bookmarkedPages = decoded
        }
    }

    private func saveBookmarks() {
        if let encoded = try? JSONEncoder().encode(bookmarkedPages) {
            bookmarkedPagesData = encoded
        }
    }

    private func toggleBookmark(for page: Int) {
        if let index = bookmarkedPages.firstIndex(of: page) {
            bookmarkedPages.remove(at: index)
        } else {
            bookmarkedPages.append(page)
        }
        saveBookmarks()
    }
}
