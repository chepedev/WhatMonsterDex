//
//  Pokemon.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 26/12/25.
//

import Foundation

// A Pokemon with basic info (name, sprite, types, favorite status)
struct Pokemon: Sendable, Identifiable, Hashable {
    let id: Int
    let name: String
    let spriteURL: URL?
    let types: [PokemonType]
    var isFavorite: Bool
    nonisolated init(id: Int, name: String, spriteURL: URL?, types: [PokemonType], isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.spriteURL = spriteURL
        self.types = types
        self.isFavorite = isFavorite
    }
}
