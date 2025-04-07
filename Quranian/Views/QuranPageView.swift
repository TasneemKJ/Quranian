//
//  QuranPageView.swift
//  Quranian
//
//  Created by Tasnim Almousa on 07/04/2025.
//

import SwiftUI

import SwiftUI

struct QuranPageView: View {
    let pageNumber: Int
    let verses: [Verse]

    var body: some View {
        VStack(spacing: 16) {
            // Surah Name
            if let surahName = verses.first?.surahName?.ar {
                Text("سورة \(surahName)")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.black)
            }

            Divider().padding(.horizontal)

            // Quran Text Block
            ScrollView {
                Text(fullVerseText())
                    .font(.custom("KFGQPCHAFSUthmanicScript-Regula", size: 20))
                    .multilineTextAlignment(.center)
                    .padding()
                    .environment(\.layoutDirection, .rightToLeft)
            }

            Divider().padding(.horizontal)

            // Page Number at Bottom
            Text("الصفحة \(pageNumber)")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.green.opacity(0.3), lineWidth: 2)
                .shadow(radius: 2)
        )
        .padding(.horizontal)
    }

    private func fullVerseText() -> String {
        verses.map { verse in
            "\(verse.text.ar) \(ayahNumberCircle(verse.number))"
        }.joined(separator: " ")
    }

    private func ayahNumberCircle(_ number: Int) -> String {
        let digits = Array(String(number)).compactMap { arabicNumberMap[$0] }
        return "﴿" + digits.joined() + "﴾"
    }

    private let arabicNumberMap: [Character: String] = [
        "0": "٠", "1": "١", "2": "٢", "3": "٣", "4": "٤",
        "5": "٥", "6": "٦", "7": "٧", "8": "٨", "9": "٩"
    ]
}
