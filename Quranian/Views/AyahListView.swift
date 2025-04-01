//
//  AyahListView.swift
//  Quranian
//
//  Created by Tasnim Almousa on 01/04/2025.
//


import SwiftUI

struct AyahListView: View {
    let surah: Surah
    @State private var fontSize: CGFloat = 20
    
    var body: some View {
        List(surah.ayahs) { ayah in
            VStack(alignment: .trailing, spacing: 8) {
                HStack {
                    Text("\(ayah.id)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.secondary)
                        .frame(width: 24)
                    Divider()
                    Text(ayah.text)
                        .font(.system(size: fontSize, design: .serif))
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("\(surah.name)")
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    fontSize = max(16, fontSize - 2)
                } label: {
                    Image(systemName: "textformat.size.smaller")
                }
                
                Button {
                    fontSize = min(32, fontSize + 2)
                } label: {
                    Image(systemName: "textformat.size.larger")
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}
