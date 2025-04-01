//
//  LoadingView.swift
//  Quranian
//
//  Created by Tasnim Almousa on 01/04/2025.
//


import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(.circular)
            Text("جاري تحميل القرآن...")
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
