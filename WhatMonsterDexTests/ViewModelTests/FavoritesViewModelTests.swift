//
//  FavoritesViewModelTests.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 30/12/25.
//

import Testing
@testable import WhatMonsterDex

@Suite("FavoritesViewModel Tests")
struct FavoritesViewModelTests {
    
    @Test("Load favorites successfully")
    @MainActor
    func testLoadFavorites() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.mockFavorites = Pokemon.mockList
        let viewModel = FavoritesViewModel(repository: mockRepository)
        
        // Act
        viewModel.loadFavorites()
        
        // Wait for async operation
        try await Task.sleep(for: .milliseconds(100))
        
        // Assert
        #expect(viewModel.favoritePokemon.count == 3)
        #expect(!viewModel.isLoading)
    }
    
    @Test("Load empty favorites list")
    @MainActor
    func testLoadEmptyFavorites() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.mockFavorites = []
        let viewModel = FavoritesViewModel(repository: mockRepository)
        
        // Act
        viewModel.loadFavorites()
        try await Task.sleep(for: .milliseconds(100))
        
        // Assert
        #expect(viewModel.favoritePokemon.isEmpty)
        #expect(!viewModel.isLoading)
    }
    
    @Test("Remove favorite Pokemon")
    @MainActor
    func testRemoveFavorite() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.mockFavorites = Pokemon.mockList
        let viewModel = FavoritesViewModel(repository: mockRepository)
        
        // Load initial favorites
        viewModel.loadFavorites()
        try await Task.sleep(for: .milliseconds(100))
        
        let initialCount = viewModel.favoritePokemon.count
        #expect(initialCount == 3)
        
        // Act - Remove a favorite
        let pokemonToRemove = viewModel.favoritePokemon[0]
        mockRepository.mockFavorites = Array(Pokemon.mockList.dropFirst())
        viewModel.removeFavorite(pokemonToRemove)
        try await Task.sleep(for: .milliseconds(100))
        
        // Assert
        #expect(viewModel.favoritePokemon.count == 2)
    }
    
    @Test("Refresh favorites list")
    @MainActor
    func testRefresh() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.mockFavorites = Pokemon.mockList
        let viewModel = FavoritesViewModel(repository: mockRepository)
        
        // Load initial favorites
        viewModel.loadFavorites()
        try await Task.sleep(for: .milliseconds(100))
        #expect(viewModel.favoritePokemon.count == 3)
        
        // Change mock data
        mockRepository.mockFavorites = [Pokemon.mockList[0]]
        
        // Act
        viewModel.refresh()
        try await Task.sleep(for: .milliseconds(100))
        
        // Assert
        #expect(viewModel.favoritePokemon.count == 1)
    }
    
    @Test("Loading state management")
    @MainActor
    func testLoadingState() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.mockFavorites = Pokemon.mockList
        let viewModel = FavoritesViewModel(repository: mockRepository)
        
        // Initial state
        #expect(!viewModel.isLoading)
        
        // Act
        viewModel.loadFavorites()
        
        // Wait for completion
        try await Task.sleep(for: .milliseconds(100))
        
        // Assert
        #expect(!viewModel.isLoading)
    }
}
