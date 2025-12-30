//
//  FetchPokemonListUseCase.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 26/12/25.
//

import Foundation

// Fetches paginated pokemon list through repository
final class FetchPokemonListUseCase: Sendable {
    private let repository: PokemonRepositoryProtocol
    
    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(offset: Int, limit: Int) async throws -> [Pokemon] {
        try await repository.fetchPokemonList(offset: offset, limit: limit)
    }
}
