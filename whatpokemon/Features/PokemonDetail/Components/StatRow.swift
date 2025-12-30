//
//  StatRow.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 29/12/25.
//

import SwiftUI

struct StatRow: View {
    let stat: Stat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(stat.displayName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(stat.baseStat)")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background bar
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                    
                    // Progress bar
                    RoundedRectangle(cornerRadius: 4)
                        .fill(statColor)
                        .frame(width: progressWidth(for: geometry.size.width), height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(stat.displayName): \(stat.baseStat)")
    }
    
    private func progressWidth(for totalWidth: CGFloat) -> CGFloat {
        let maxStat: CGFloat = 255 // Max possible stat value in Pokemon
        let percentage = CGFloat(stat.baseStat) / maxStat
        return totalWidth * min(percentage, 1.0)
    }
    
    private var statColor: Color {
        let value = stat.baseStat
        switch value {
        case 0..<50: return .red
        case 50..<75: return .orange
        case 75..<100: return .yellow
        case 100..<125: return .green
        default: return .blue
        }
    }
}
