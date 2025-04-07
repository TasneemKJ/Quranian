//
//  QuranPagerView.swift
//  Quranian
//
//  Created by Tasnim Almousa on 07/04/2025.
//
import SwiftUI

struct QuranPagerView: View {
    @StateObject private var manager = QuranPageManager(verses: QuranDataManager.loadFromJSON())

    var body: some View {
        TabView {
            ForEach(1...manager.totalPages, id: \.self) { pageNumber in
                if let verses = manager.getPage(pageNumber) {
                    QuranPageView(pageNumber: pageNumber, verses: verses)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .environment(\.layoutDirection, .rightToLeft)
        .edgesIgnoringSafeArea(.all)
    }
}
