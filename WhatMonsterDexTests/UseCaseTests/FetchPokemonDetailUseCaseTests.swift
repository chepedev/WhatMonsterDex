//
//  FetchPokemonDetailUseCaseTests.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 30/12/25.
//

import Testing
@testable import WhatMonsterDex

@Suite("FetchPokemonDetailUseCase Tests")
struct FetchPokemonDetailUseCaseTests {
    
    @Test("Execute use case successfully")
    @MainActor
    func testExecuteSuccess() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.mockDetail = PokemonDetail.mock
        let useCase = FetchPokemonDetailUseCase(repository: mockRepository)
        
        // Act
        let result = try await useCase.execute(pokemonID: 1)
        
        // Assert
        #expect(result.id == 1)
        #expect(result.name == "bulbasaur")
    }
    
    @Test("Execute use case with error")
    @MainActor
    func testExecuteError() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        mockRepository.shouldFail = true
        let useCase = FetchPokemonDetailUseCase(repository: mockRepository)
        
        // Act & Assert
        do {
            _ = try await useCase.execute(pokemonID: 1)
            Issue.record("Expected error to be thrown")
        } catch {
            #expect(error is NetworkError)
        }
    }
    
    @Test("Execute use case for different Pokemon IDs")
    @MainActor
    func testExecuteMultipleIDs() async throws {
        // Arrange
        let mockRepository = MockPokemonRepository()
        let useCase = FetchPokemonDetailUseCase(repository: mockRepository)
        
        // Test multiple Pokemon IDs
        let testIDs = [1, 25, 150]
        
        for id in testIDs {
            // Update mock for each ID
            mockRepository.mockDetail = PokemonDetail(
                id: id,
                name: "pokemon\(id)",
                height: 10,
                weight: 100,
                stats: [],
                types: [],
                sprites: PokemonSprite(frontDefault: nil, frontShiny: nil, backDefault: nil, backShiny: nil)
            )
            
            // Act
            let result = try await useCase.execute(pokemonID: id)
            
            // Assert
            #expect(result.id == id)
        }
    }
}
