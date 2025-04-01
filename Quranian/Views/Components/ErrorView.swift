//
//  ErrorView.swift
//  Quranian
//
//  Created by Tasnim Almousa on 01/04/2025.
//


import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("BackgroundStart"), Color("BackgroundEnd")]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(Color("AccentColor"))
                
                Text("Oops!")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(error.localizedDescription)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 30)
                
                Button(action: retryAction) {
                    Text("Try Again")
                        .fontWeight(.medium)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("ButtonBackground"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
            }
            .padding()
        }
    }
}
