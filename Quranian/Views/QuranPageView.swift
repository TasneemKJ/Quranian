//
//  QuranPageView.swift
//  Quranian
//
//  Created by Tasnim Almousa on 07/04/2025.
//

import SwiftUI

struct QuranPageView: View {
    let pageNumber: Int
    let verses: [Verse]

    var body: some View {
        VStack(spacing: 16) {
            Text("الصفحة \(pageNumber)")
                .font(.headline)
                .foregroundColor(.gray)

            Divider().padding(.horizontal)

            ForEach(verses) { verse in
                HStack {
                    Spacer()
                    Text(verseDisplay(verse))
                        .font(.custom("KFGQPCHAFSUthmanicScript-Regula", size: 26))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .lineLimit(nil)
                    Spacer()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.green.opacity(0.3), lineWidth: 2)
                .shadow(radius: 3)
        )
        .padding()
        .environment(\.layoutDirection, .rightToLeft)
    }

    private func verseDisplay(_ verse: Verse) -> String {
        let ayahStop = "\u{06DD}" // ۝
        return "\(verse.text.ar) \(ayahStop)"
    }
}
