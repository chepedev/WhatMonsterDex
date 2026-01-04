//
//  FavoritesViewModel.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 29/12/25.
//

import Foundation
import Observation

// Manages the Favorites screen
@MainActor
@Observable
final class FavoritesViewModel {
    
    private(set) var favoritePokemon: [Pokemon] = []
    private(set) var isLoading = false
    private let repository: PokemonRepositoryProtocol
    
    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }
        
    func loadFavorites() {
        isLoading = true
        
        Task {
            favoritePokemon = await repository.getFavorites()
            isLoading = false
        }
    }
    
    func removeFavorite(_ pokemon: Pokemon) {
        Task {
            _ = await repository.toggleFavorite(id: pokemon.id)
            loadFavorites()
        }
    }
    
    func refresh() {
        loadFavorites()
    }
}
