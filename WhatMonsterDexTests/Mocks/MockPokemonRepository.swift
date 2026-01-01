//
//  MockPokemonRepository.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 30/12/25.
//

import Foundation
@testable import WhatMonsterDex

/// Mock implementation of PokemonRepository for testing
final class MockPokemonRepository: PokemonRepositoryProtocol, @unchecked Sendable {
    var shouldFail = false
    var mockPokemon: [Pokemon] = []
    var mockDetail: PokemonDetail?
    var mockFavorites: [Pokemon] = []
    var favoriteIDs: Set<Int> = []
    
    func fetchPokemonList(offset: Int, limit: Int) async throws -> [Pokemon] {
        if shouldFail {
            throw NetworkError.noInternetConnection
        }
        return mockPokemon
    }
    
    func fetchPokemonDetail(id: Int) async throws -> PokemonDetail {
        if shouldFail {
            throw NetworkError.noInternetConnection
        }
        guard let detail = mockDetail else {
            throw NetworkError.invalidResponse
        }
        return detail
    }
    
    func toggleFavorite(id: Int) async -> Bool {
        if favoriteIDs.contains(id) {
            favoriteIDs.remove(id)
            return false
        } else {
            favoriteIDs.insert(id)
            return true
        }
    }
    
    func isFavorite(id: Int) async -> Bool {
        return favoriteIDs.contains(id)
    }
    
    func getFavorites() async -> [Pokemon] {
        return mockFavorites
    }
    
    func getCachedPokemonCount() async -> Int {
        return mockPokemon.count
    }
}

// MARK: - Mock Data

extension Pokemon {
    static var mock: Pokemon {
        Pokemon(
            id: 1,
            name: "bulbasaur",
            spriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"),
            types: [PokemonType(name: "grass"), PokemonType(name: "poison")]
        )
    }
    
    static var mockList: [Pokemon] {
        [
            Pokemon(id: 1, name: "bulbasaur", spriteURL: nil, types: [PokemonType(name: "grass")]),
            Pokemon(id: 2, name: "ivysaur", spriteURL: nil, types: [PokemonType(name: "grass")]),
            Pokemon(id: 3, name: "venusaur", spriteURL: nil, types: [PokemonType(name: "grass")])
        ]
    }
}

extension PokemonDetail {
    static var mock: PokemonDetail {
        PokemonDetail(
            id: 1,
            name: "bulbasaur",
            height: 7,
            weight: 69,
            stats: [
                Stat(name: "hp", baseStat: 45, effort: 0),
                Stat(name: "attack", baseStat: 49, effort: 0),
                Stat(name: "defense", baseStat: 49, effort: 0)
            ],
            types: [PokemonType(name: "grass"), PokemonType(name: "poison")],
            sprites: PokemonSprite(
                frontDefault: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"),
                frontShiny: nil,
                backDefault: nil,
                backShiny: nil
            )
        )
    }
}
