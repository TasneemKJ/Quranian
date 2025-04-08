//
//  BookmarksView.swift
//  Quranian
//
//  Created by Tasnim Almousa on 08/04/2025.
//


import SwiftUI

struct BookmarksView: View {
    @AppStorage("bookmarkedPages") private var bookmarkedPagesData: Data = Data()
    @AppStorage("lastQuranPage") private var selectedPage: Int = 1
    @Environment(\.dismiss) var dismiss

    private var bookmarkedPages: [Int] {
        (try? JSONDecoder().decode([Int].self, from: bookmarkedPagesData)) ?? []
    }

    var body: some View {
        NavigationView {
            List(bookmarkedPages.sorted(), id: \.self) { page in
                Button(action: {
                    selectedPage = page
                    dismiss()
                }) {
                    Text("📖 الصفحة \(page)")
                }
            }
            .navigationTitle("الصفحات المحفوظة")
        }
    }
}