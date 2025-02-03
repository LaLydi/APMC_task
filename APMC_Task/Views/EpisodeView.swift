//
//  EpisodeView.swift
//  APMC_Task
//
//  Created by Lydia on 2025-02-03.
//

import SwiftUI

struct EpisodeView: View {
    let title: String
    let duration: String
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.random)
                .frame(maxWidth: .infinity, minHeight: 120, maxHeight: 150)
            HStack {
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                Spacer()
                Text(duration)
                    .font(.caption)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    EpisodeView(title: "Test Title", duration: "12:34")
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
