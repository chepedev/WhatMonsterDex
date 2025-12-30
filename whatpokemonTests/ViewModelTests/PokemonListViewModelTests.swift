//
//  PokemonListViewModelTests.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 30/12/25.
//

import Testing
@testable import whatpokemon

@Suite("PokemonListViewModel Tests")
struct PokemonListViewModelTests {
    
    @Test("Load first page successfully")
    @MainActor
    func testLoadFirstPage() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.mockPokemon = Pokemon.mockList
        let useCase = FetchPokemonListUseCase(repository: mockRepository)
        let viewModel = PokemonListViewModel(useCase: useCase, repository: mockRepository)
        
        // Act
        viewModel.loadNextPage()
        
        // Wait for async operation
        try await Task.sleep(for: .milliseconds(100))
        
        // Assert
        #expect(viewModel.pokemon.count == 3)
        #expect(!viewModel.isLoading)
        #expect(viewModel.hasMorePages)
    }
    
    @Test("Handle network error gracefully")
    @MainActor
    func testNetworkError() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.shouldFail = true
        let useCase = FetchPokemonListUseCase(repository: mockRepository)
        let viewModel = PokemonListViewModel(useCase: useCase, repository: mockRepository)
        
        // Act
        viewModel.loadNextPage()
        try await Task.sleep(for: .milliseconds(100))
        
        // Assert
        #expect(viewModel.toastMessage != nil)
        #expect(viewModel.toastType == .error)
    }
    
    @Test("Refresh clears existing data")
    @MainActor
    func testRefresh() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.mockPokemon = Pokemon.mockList
        let useCase = FetchPokemonListUseCase(repository: mockRepository)
        let viewModel = PokemonListViewModel(useCase: useCase, repository: mockRepository)
        
        // Load initial data
        viewModel.loadNextPage()
        try await Task.sleep(for: .milliseconds(100))
        
        let initialCount = viewModel.pokemon.count
        #expect(initialCount > 0)
        
        // Act
        viewModel.refresh()
        
        // Assert
        #expect(viewModel.pokemon.isEmpty)
        #expect(viewModel.hasMorePages)
    }
}
