//
//  SurahListView.swift
//  Quranian
//
//  Created by Tasnim Almousa on 01/04/2025.
//


import SwiftUI

struct SurahListView: View {
    @StateObject private var quranManager = QuranDataManager()
    @State private var searchText = ""
    
    var filteredSurahs: [Surah] {
        if searchText.isEmpty {
            return quranManager.surahs
        } else {
            return quranManager.surahs.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if quranManager.isLoading {
                    LoadingView()
                } else if let error = quranManager.error {
                    ErrorView(error: error, retryAction: {
                        Task { quranManager.loadSurahs() }
                    })
                } else {
                    List(filteredSurahs) { surah in
                        NavigationLink(destination: AyahListView(surah: surah)) {
                            SurahRowView(surah: surah)
                                .listRowSeparator(.hidden)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(InsetGroupedListStyle())
                    .scrollContentBackground(.hidden)
                    .background(Color(.systemBackground))
                }
            }
            .navigationTitle("")
            .searchable(text: $searchText, prompt: "بحث")
            .refreshable {
                quranManager.loadSurahs()
            }
        }
        .background(Color(.systemBackground))

        .environment(\.layoutDirection, .rightToLeft)
    }
}

struct SurahRowView: View {
    let surah: Surah
    
    var body: some View {
        HStack {
            Text("\(surah.id)")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 24)
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(surah.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.trailing)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 10)
        .environment(\.layoutDirection, .rightToLeft)
    }
}
