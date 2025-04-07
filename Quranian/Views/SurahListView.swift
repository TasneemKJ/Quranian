import SwiftUI

struct SurahListView: View {
    @State private var searchText: String = ""
    let surahs: [SurahInfo]
    let onSelect: (SurahInfo) -> Void

    var filteredSurahs: [SurahInfo] {
        if searchText.isEmpty { return surahs }
        return surahs.filter {
            $0.nameAr.contains(searchText)
            || $0.nameEn.localizedCaseInsensitiveContains(searchText)
            || "\($0.id)".contains(searchText)
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredSurahs) { surah in
                    Button(action: {
                        onSelect(surah)
                    }) {
                        HStack(spacing: 12) {
                            // Surah number badge
                            Text("\(surah.id)")
                                .font(.caption)
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .background(Color.blue)
                                .clipShape(Circle())

                            VStack(alignment: .trailing, spacing: 2) {
                                // Arabic name
                                Text(surah.nameAr)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.primary)
                                
                            }

                            Spacer()

                            // Page number
                            Text("صفحة \(surah.page)")
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(14)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("اختر السورة")
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
