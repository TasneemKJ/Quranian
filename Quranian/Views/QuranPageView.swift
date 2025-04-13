import SwiftUI

struct QuranPageView: View {
    let pageNumber: Int
    let verses: [Verse]
    
    @AppStorage("quranFontSize") private var fontSize: Double = 17
    @State private var magnifyBy: CGFloat = 1.0
    @StateObject private var orientationObserver = OrientationObserver()
    @State private var selectedVerse: Verse? = nil
    @State private var showTooltip: Bool = false
    
    // MARK: - Constants
    private let minFontSize: Double = 10
    private let maxFontSize: Double = 60
    private let contentWidthRatio: CGFloat = 0.8
    private let arabicNumberMap: [Character: String] = [
        "0": "٠", "1": "١", "2": "٢", "3": "٣", "4": "٤",
        "5": "٥", "6": "٦", "7": "٧", "8": "٨", "9": "٩"
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Divider().padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(groupedBySurah.keys.sorted(), id: \.self) { surahNumber in
                        if let verses = groupedBySurah[surahNumber], let surahName = verses.first?.surahName?.ar {
                            surahSection(surahName: surahName, verses: verses)
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 12)
            }
            
            zoomControls
                .padding(.top, 4)
            
            pageNumberFooter
        }
        .padding(.horizontal)
        .onChange(of: orientationObserver.orientation) { _ in
            withAnimation { _ = UUID() } // Force view update
        }
    }
    
    // MARK: - Computed Properties
    private var groupedBySurah: [Int: [Verse]] {
        Dictionary(grouping: verses, by: { $0.surahNumber ?? -1 })
    }
    
    private var pageNumberFooter: some View {
        Text("الصفحة \(pageNumber)")
            .font(.footnote)
            .foregroundColor(.gray)
            .padding(.bottom, 8)
    }
    
    // MARK: - View Components
    private func surahSection(surahName: String, verses: [Verse]) -> some View {
        VStack(spacing: 12) {
            surahHeader(surahName: surahName)
            
            if shouldShowBasmala(for: verses.first?.surahNumber ?? 0),
               verses.contains(where: { $0.number == 1 }) {
                basmalaView
            }
            
            versesContainer(verses: verses)
                .frame(width: UIScreen.main.bounds.width * contentWidthRatio)
                .padding(.horizontal)
        }
    }
    
    private func surahHeader(surahName: String) -> some View {
        VStack{
            Text("سورة \(surahName)")
                .font(.title3.bold())
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.green.opacity(0.1))
                .clipShape(Capsule())
        }
    }
    
    private var basmalaView: some View {
        Text("بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ")
            .font(.custom("KFGQPCHAFSUthmanicScript-Regula", size: CGFloat(fontSize - 5)))
            .multilineTextAlignment(.center)
    }
    
    private func versesContainer(verses: [Verse]) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.green.opacity(0.3), lineWidth: 2)
                .background(Color.white.opacity(0.0001))
                .shadow(radius: 2)
            
            ScrollView {
                ZStack {
                    Text(renderVersesAttributed(verses))
                        .font(.custom("KFGQPCHAFSUthmanicScript-Regula", size: CGFloat(fontSize) * magnifyBy))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding()
                        .environment(\.layoutDirection, .rightToLeft)
                        .environment(\.openURL, OpenURLAction(handler: { url in
                            handleVerseSelection(url: url)
                            return .handled
                        }))
                    
                    if let verse = selectedVerse, showTooltip {
                        tooltipView(for: verse)
                            .offset(y: -50)
                            .transition(.opacity)
                    }
                }
                .gesture(magnificationGesture)
            }
        }
    }
    
    private func tooltipView(for verse: Verse) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(verse.text.en)
                .font(.system(size: fontSize, weight: .medium))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .environment(\.layoutDirection, .leftToRight)
            
            Text("Surah \(verse.surahName?.en ?? "") : \(verse.number)")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
        }
        .padding(12)
        .frame(maxWidth: 280)
        .background(.ultraThinMaterial)
        .background(Color.blue.opacity(0.3))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        .onTapGesture {
            withAnimation {
                showTooltip = false
                selectedVerse = nil
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showTooltip = false
                    selectedVerse = nil
                }
            }
        }
    }
    
    private var zoomControls: some View {
        HStack(spacing: 16) {
            Button(action: decreaseFontSize) {
                Text("A−")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color(UIColor.systemGray6))
                    .clipShape(Capsule())
            }
            
            Button(action: increaseFontSize) {
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
    
    // MARK: - Gestures
    private var magnificationGesture: some Gesture {
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
    }
    
    // MARK: - Helper Methods
    private func shouldShowBasmala(for surahNumber: Int) -> Bool {
        return surahNumber != 1 && surahNumber != 9
    }
    
    private func renderVersesAttributed(_ verses: [Verse]) -> AttributedString {
        var complete = AttributedString("")
        for verse in verses {
            var vstr = AttributedString("\(verse.text.ar) \(ayahNumberCircle(verse.number)) ")
            if let url = URL(string: "quran://\(verse.surahNumber ?? 0)_\(verse.number)") {
                vstr.link = url
                vstr.foregroundColor = .black
            }
            
            complete += vstr
        }
        return complete
    }
    
    private func ayahNumberCircle(_ number: Int) -> String {
        let digits = Array(String(number)).compactMap { arabicNumberMap[$0] }
        return "﴿" + digits.joined() + "﴾"
    }
    
    private func handleVerseSelection(url: URL) {
        let path = url.absoluteString.replacingOccurrences(of: "quran://", with: "")
        let components = path.split(separator: "_")
        
        guard components.count == 2,
              let surah = Int(components[0]),
              let number = Int(components[1]),
              let verse = verses.first(where: { $0.surahNumber == surah && $0.number == number }) else {
            return
        }
        
        selectedVerse = verse
        showTooltip = true
    }
    
    private func decreaseFontSize() {
        withAnimation {
            fontSize = max(minFontSize, fontSize - 2)
        }
    }
    
    private func increaseFontSize() {
        withAnimation {
            fontSize = min(maxFontSize, fontSize + 2)
        }
    }
}
