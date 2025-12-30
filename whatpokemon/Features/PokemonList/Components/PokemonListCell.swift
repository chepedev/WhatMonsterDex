//
//  PokemonListCell.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 28/12/25.
//

import SwiftUI
import Kingfisher

struct PokemonListCell: View {
    let pokemon: Pokemon
    
    var body: some View {
        HStack(spacing: 12) {
            KFImage(pokemon.spriteURL)
                .placeholder {
                    ProgressView()
                }
                .onFailure { error in
                    print(error)
                }
                .retry(maxCount: 1, interval: .seconds(1))
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .accessibilityLabel("Sprite of \(pokemon.name)")
            
            VStack(alignment: .leading, spacing: 4) {
                Text(pokemon.name.capitalized)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if !pokemon.types.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(pokemon.types, id: \.name) { type in
                            Text(type.name.capitalized)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: type.color).opacity(0.3))
                                .foregroundColor(Color(hex: type.color))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(pokemon.name), types: \(pokemon.types.map(\.name).joined(separator: ", "))")
    }
}
