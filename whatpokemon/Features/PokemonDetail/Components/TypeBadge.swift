//
//  TypeBadge.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 29/12/25.
//

import SwiftUI

struct TypeBadge: View {
    let type: PokemonType
    
    var body: some View {
        Text(type.name.capitalized)
            .font(.subheadline)
            .fontWeight(.semibold)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(hex: type.color))
            .foregroundColor(.white)
            .cornerRadius(20)
            .shadow(color: Color(hex: type.color).opacity(0.3), radius: 4, x: 0, y: 2)
            .accessibilityLabel("Type: \(type.name)")
    }
}
