//
//  PokemonDetail.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 27/12/25.
//

import Foundation

// Full Pokemon details: stats, sprites, height, weight, etc.
struct PokemonDetail: Sendable, Identifiable {
    let id: Int
    let name: String
    let height: Int // in decimeters
    let weight: Int // in hectograms this comes from API, i.e: 690 hectograms → 69.0 kg
    let stats: [Stat]
    let types: [PokemonType]
    let sprites: PokemonSprite
    
    var heightInMeters: Double {
        Double(height) / 10.0
    }
    
    var weightInKilograms: Double {
        Double(weight) / 10.0
    }
}

struct Stat: Sendable, Hashable, Codable {
    let name: String
    let baseStat: Int
    let effort: Int
    
    var displayName: String {
        switch name.lowercased() {
        case "hp": return "HP"
        case "attack": return "Attack"
        case "defense": return "Defense"
        case "special-attack": return "Sp. Atk"
        case "special-defense": return "Sp. Def"
        case "speed": return "Speed"
        default: return name.capitalized
        }
    }
}

struct PokemonSprite: Sendable, Hashable, Codable {
    let frontDefault: URL?
    let frontShiny: URL?
    let backDefault: URL?
    let backShiny: URL?
    
    nonisolated init(frontDefault: URL?, frontShiny: URL?, backDefault: URL?, backShiny: URL?) {
        self.frontDefault = frontDefault
        self.frontShiny = frontShiny
        self.backDefault = backDefault
        self.backShiny = backShiny
    }
}
