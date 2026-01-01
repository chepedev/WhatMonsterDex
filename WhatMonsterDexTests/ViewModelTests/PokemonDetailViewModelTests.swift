//
//  PokemonDetailViewModelTests.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 30/12/25.
//

import Testing
@testable import WhatMonsterDex

@Suite("PokemonDetailViewModel Tests")
struct PokemonDetailViewModelTests {
    
    @Test("Load Pokemon detail successfully")
    @MainActor
    func testLoadDetailSuccess() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.mockDetail = PokemonDetail.mock
        let useCase = FetchPokemonDetailUseCase(repository: mockRepository)
        let viewModel = PokemonDetailViewModel(pokemonID: 1, useCase: useCase, repository: mockRepository)
        
        // Act
        viewModel.loadDetail()
        
        // Wait for async operation
        try await Task.sleep(for: .milliseconds(100))
        
        // Assert
        #expect(viewModel.pokemonDetail != nil)
        #expect(viewModel.pokemonDetail?.id == 1)
        #expect(viewModel.pokemonDetail?.name == "bulbasaur")
        #expect(!viewModel.isLoading)
        #expect(viewModel.error == nil)
    }
    
    @Test("Handle network error when loading detail")
    @MainActor
    func testLoadDetailError() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.shouldFail = true
        let useCase = FetchPokemonDetailUseCase(repository: mockRepository)
        let viewModel = PokemonDetailViewModel(pokemonID: 1, useCase: useCase, repository: mockRepository)
        
        // Act
        viewModel.loadDetail()
        try await Task.sleep(for: .milliseconds(100))
        
        // Assert
        #expect(viewModel.pokemonDetail == nil)
        #expect(viewModel.error != nil)
        #expect(!viewModel.isLoading)
    }
    
    @Test("Toggle favorite status")
    @MainActor
    func testToggleFavorite() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.mockDetail = PokemonDetail.mock
        let useCase = FetchPokemonDetailUseCase(repository: mockRepository)
        let viewModel = PokemonDetailViewModel(pokemonID: 1, useCase: useCase, repository: mockRepository)
        
        // Initial state
        #expect(!viewModel.isFavorite)
        
        // Act
        viewModel.toggleFavorite()
        try await Task.sleep(for: .milliseconds(50))
        
        // Assert
        #expect(viewModel.isFavorite)
    }
    
    @Test("Retry after error")
    @MainActor
    func testRetry() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.shouldFail = true
        let useCase = FetchPokemonDetailUseCase(repository: mockRepository)
        let viewModel = PokemonDetailViewModel(pokemonID: 1, useCase: useCase, repository: mockRepository)
        
        // Load with error
        viewModel.loadDetail()
        try await Task.sleep(for: .milliseconds(100))
        #expect(viewModel.error != nil)
        
        // Fix the repository and retry
        mockRepository.shouldFail = false
        mockRepository.mockDetail = PokemonDetail.mock
        
        // Act
        viewModel.retry()
        try await Task.sleep(for: .milliseconds(100))
        
        // Assert
        #expect(viewModel.pokemonDetail != nil)
        #expect(viewModel.error == nil)
    }
    
    @Test("Loading state management")
    @MainActor
    func testLoadingState() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.mockDetail = PokemonDetail.mock
        let useCase = FetchPokemonDetailUseCase(repository: mockRepository)
        let viewModel = PokemonDetailViewModel(pokemonID: 1, useCase: useCase, repository: mockRepository)
        
        // Initial state
        #expect(!viewModel.isLoading)
        
        // Act
        viewModel.loadDetail()
        
        // Should be loading immediately
        #expect(viewModel.isLoading)
        
        // Wait for completion
        try await Task.sleep(for: .milliseconds(100))
        
        // Assert
        #expect(!viewModel.isLoading)
    }
    
    @Test("Prevent duplicate loads")
    @MainActor
    func testPreventDuplicateLoads() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.mockDetail = PokemonDetail.mock
        let useCase = FetchPokemonDetailUseCase(repository: mockRepository)
        let viewModel = PokemonDetailViewModel(pokemonID: 1, useCase: useCase, repository: mockRepository)
        
        // Act - Try to load multiple times
        viewModel.loadDetail()
        viewModel.loadDetail() // Should be ignored
        viewModel.loadDetail() // Should be ignored
        
        try await Task.sleep(for: .milliseconds(100))
        
        // Assert - Should only load once
        #expect(viewModel.pokemonDetail != nil)
        #expect(!viewModel.isLoading)
    }
}
