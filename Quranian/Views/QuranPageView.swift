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
        ScrollView {
            VStack(alignment: .trailing, spacing: 16) {
                Text("الصفحة \(pageNumber)")
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 8)

                ForEach(verses) { verse in
                    Text(verse.text.ar)
                        .font(.title2)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom, 4)
                }
            }
            .padding()
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}
