//
//  Tasbee7View.swift
//  Quranian
//
//  Created by Tasnim Almousa on 03/04/2025.
//


import SwiftUI

struct Tasbee7View: View {
    @AppStorage("tasbee7Count") private var count: Int = UserDefaults.standard.integer(forKey: "tasbee7Count")

    var body: some View {
        VStack(spacing: 40) {
            Text("\(count)")
                .font(.system(size: 72, weight: .bold))
                .padding()

            Button(action: {
                count += 1
                UserDefaults.standard.set(count, forKey: "tasbee7Count")
            }) {
                Circle()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.green.opacity(0.7))
            }

            Button("تصفير") {
                count = 0
                UserDefaults.standard.set(count, forKey: "tasbee7Count")
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}
