import SwiftUI

struct QuranPageView: View {
    let pageNumber: Int
    let verses: [Verse]

    @AppStorage("quranFontSize") private var fontSize: Double = 17
    @State private var magnifyBy: CGFloat = 1.0
    @StateObject private var orientationObserver = OrientationObserver()

    // MARK: - Font Size Limits
    private let minFontSize: Double = 10
    private let maxFontSize: Double = 60

    var body: some View {
        VStack(spacing: 12) {
            Divider().padding(.horizontal)

            ScrollView {
                VStack(spacing: 24) {
                    ForEach(groupedBySurah.keys.sorted(), id: \.self) { surahNumber in
                        if let verses = groupedBySurah[surahNumber],
                           let surahName = verses.first?.surahName?.ar {

                            VStack(spacing: 12) {
                                Text("سورة \(surahName)")
                                    .font(.title3.bold())
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.green.opacity(0.1))
                                    .clipShape(Capsule())

                                if shouldShowBasmala(for: surahNumber),
                                   verses.contains(where: { $0.number == 1 }) {
                                    Text("بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ")
                                        .font(.custom("KFGQPCHAFSUthmanicScript-Regula", size: CGFloat(fontSize - 5)))
                                        .multilineTextAlignment(.center)
                                }

                                ZStack {
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color.green.opacity(0.3), lineWidth: 2)
                                        .background(Color.white.opacity(0.0001))
                                        .shadow(radius: 2)

                                    ScrollView {
                                        Text(renderVerses(verses))
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
                                                            fontSize = min(max(minFontSize, fontSize * Double(magnifyBy)), maxFontSize)
                                                            magnifyBy = 1.0
                                                        }
                                                    }
                                            )
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.8)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 12)
            }

            zoomControls
                .padding(.top, 4)

            Text("الصفحة \(pageNumber)")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 8)
        }
        .padding(.horizontal)
        .onChange(of: orientationObserver.orientation) { _ in
            // 👇 This line forces the view to redraw on orientation change.
            withAnimation { _ = UUID() }
        }
    }

    private var groupedBySurah: [Int: [Verse]] {
        Dictionary(grouping: verses, by: { $0.surahNumber ?? -1 })
    }

    private func shouldShowBasmala(for surahNumber: Int) -> Bool {
        return surahNumber != 1 && surahNumber != 9
    }

    private func renderVerses(_ verses: [Verse]) -> String {
        verses.map { verse in
            let line = "\(verse.text.ar) \(ayahNumberCircle(verse.number))"
            if verse.number == 1 && verse.surahNumber == 1 {
                return "\(line)\n"
            } else {
                return line
            }
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
