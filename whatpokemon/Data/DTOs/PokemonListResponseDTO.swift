//
//  PokemonListResponseDTO.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 26/12/25.
//

import Foundation

struct PokemonListResponseDTO: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonResultDTO]
}

struct PokemonResultDTO: Codable {
    let name: String
    let url: String
    
    // Pulls the pokemon ID from the URL (e.g "/pokemon/25/" → 25)
    nonisolated var extractedID: Int? {
        guard let url = URL(string: url) else { return nil }
        let components = url.pathComponents.filter { $0 != "/" }
        guard let lastComponent = components.last,
              let id = Int(lastComponent) else { return nil }
        return id
    }
    
    // Builds the sprite image URL from the Pokemon ID
    nonisolated var spriteURL: URL? {
        guard let id = extractedID else { return nil }
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
    }
}
