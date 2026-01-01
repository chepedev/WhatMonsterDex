//
//  PokemonRepositoryProtocol.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 26/12/25.
//

import Foundation

// Defines all Pokemon data operations - fetching, caching, and favorites
protocol PokemonRepositoryProtocol: Sendable {
    func fetchPokemonList(offset: Int, limit: Int) async throws -> [Pokemon]
    
    func fetchPokemonDetail(id: Int) async throws -> PokemonDetail
    
    // Star/unstar a pokemon
    func toggleFavorite(id: Int) async -> Bool
    
    // Check if pokemon is starred
    func isFavorite(id: Int) async -> Bool
    
    // Get all starred pokemons
    func getFavorites() async -> [Pokemon]
    
    // How many pokemon are saved offline
    func getCachedPokemonCount() async -> Int
}
