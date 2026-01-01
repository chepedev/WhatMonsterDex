//
//  FetchPokemonListUseCaseTests.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 30/12/25.
//

import Testing
@testable import WhatMonsterDex

@Suite("FetchPokemonListUseCase Tests")
struct FetchPokemonListUseCaseTests {
    
    @Test("Execute use case successfully")
    @MainActor
    func testExecuteSuccess() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.mockPokemon = Pokemon.mockList
        let useCase = FetchPokemonListUseCase(repository: mockRepository)
        
        // Act
        let results = try await useCase.execute(offset: 0, limit: 20)
        
        // Assert
        #expect(results.count == 3)
    }
    
    @Test("Execute use case with error")
    @MainActor
    func testExecuteError() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.shouldFail = true
        let useCase = FetchPokemonListUseCase(repository: mockRepository)
        
        // Act & Assert
        do {
            _ = try await useCase.execute(offset: 0, limit: 20)
            Issue.record("Expected error to be thrown")
        } catch {
            #expect(error is NetworkError)
        }
    }
    
    @Test("Execute use case with pagination")
    @MainActor
    func testExecuteWithPagination() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.mockPokemon = Pokemon.mockList
        let useCase = FetchPokemonListUseCase(repository: mockRepository)
        
        // Act - Fetch first page
        let firstPageResults = try await useCase.execute(offset: 0, limit: 20)
        
        // Act - Fetch second page
        let secondPageResults = try await useCase.execute(offset: 20, limit: 20)
        
        // Assert
        #expect(!firstPageResults.isEmpty)
        #expect(!secondPageResults.isEmpty)
    }
}
