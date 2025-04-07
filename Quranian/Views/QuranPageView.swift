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

    @State private var fontSize: CGFloat = 20
    @State private var magnifyBy: CGFloat = 1.0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 16) {
                // Surah Name
                if let surahName = verses.first?.surahName?.ar {
                    Text("سورة \(surahName)")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.primary)
                }

                Divider().padding(.horizontal)

                // Quran Text Block
                ScrollView {
                    Text(fullVerseText())
                        .font(.custom("KFGQPCHAFSUthmanicScript-Regula", size: fontSize))
                        .multilineTextAlignment(.center)
                        .padding()
                        .environment(\.layoutDirection, .rightToLeft)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { scale in
                                    magnifyBy = min(max(0.6, scale), 2.0)
                                }
                                .onEnded { _ in
                                    withAnimation(.easeInOut) {
                                        fontSize = min(max(18, fontSize * magnifyBy), 60)
                                        magnifyBy = 1.0
                                    }
                                }
                        )
                }

                Divider().padding(.horizontal)

                // Page Number
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

            // Zoom Buttons
            zoomControls
        }
    }

    // MARK: - Full Ayah Text
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

    // MARK: - Zoom Buttons
    private var zoomControls: some View {
        VStack {
            Button(action: {
                withAnimation { fontSize += 2 }
            }) {
                Image(systemName: "plus.magnifyingglass")
                    .font(.title2)
            }
            .accessibilityLabel("تكبير الخط")
            .padding(.bottom, 4)

            Button(action: {
                withAnimation { fontSize = max(18, fontSize - 2) }
            }) {
                Image(systemName: "minus.magnifyingglass")
                    .font(.title2)
            }
            .accessibilityLabel("تصغير الخط")
        }
        .padding()
    }
}
