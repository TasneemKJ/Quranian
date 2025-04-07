import SwiftUI

struct QuranPageView: View {
    let pageNumber: Int
    let verses: [Verse]

    @AppStorage("quranFontSize") private var fontSize: Double = 28
    @State private var magnifyBy: CGFloat = 1.0

    // MARK: - Font Size Limits
    private let minFontSize: CGFloat = 15
    private let maxFontSize: CGFloat = 40

    var body: some View {
        VStack(spacing: 12) {
            // Surah Title
            if let surahName = verses.first?.surahName?.ar {
                Text("سورة \(surahName)")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.primary)
            }

            Divider().padding(.horizontal)

            // Quran Text
            ScrollView {
                Text(fullVerseText())
                    .font(.custom("KFGQPCHAFSUthmanicScript-Regula", size: CGFloat(fontSize) * magnifyBy))
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
                                    fontSize = min(max(minFontSize, fontSize * magnifyBy), maxFontSize)
                                    magnifyBy = 1.0
                                }
                            }
                    )
            }

            // Font Controls above page number
            zoomControls
                .padding(.top, 8)

            // Page Number
            Text("الصفحة \(pageNumber)")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 8)
        }
        .padding(.horizontal)
    }

    // MARK: - Render Ayah Text
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

    // MARK: - Zoom Controls (Above Page Number)
    private var zoomControls: some View {
        HStack(spacing: 16) {
            Button(action: {
                withAnimation {
                    fontSize = max(minFontSize, fontSize - 2)
                }
            }) {
                Text("A−")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color(UIColor.systemGray6))
                    .clipShape(Capsule())
            }

            Button(action: {
                withAnimation {
                    fontSize = min(maxFontSize, fontSize + 2)
                }
            }) {
                Text("A+")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color(UIColor.systemGray6))
                    .clipShape(Capsule())
            }
        }
        .padding(10)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .shadow(radius: 3)
    }
}
