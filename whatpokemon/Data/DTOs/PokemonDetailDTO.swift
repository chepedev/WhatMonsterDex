//
//  PokemonDetailDTO.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 26/12/25.
//

import Foundation

struct PokemonDetailDTO: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let stats: [StatDTO]
    let types: [TypeSlotDTO]
    let sprites: SpritesDTO
}

struct StatDTO: Codable {
    let baseStat: Int
    let effort: Int
    let stat: NamedResourceDTO
}

struct TypeSlotDTO: Codable {
    let slot: Int
    let type: NamedResourceDTO
}

struct NamedResourceDTO: Codable {
    let name: String
    let url: String
}

struct SpritesDTO: Codable {
    let frontDefault: String?
    let frontShiny: String?
    let backDefault: String?
    let backShiny: String?
}
