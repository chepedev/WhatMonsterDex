//
//  FetchPokemonDetailUseCase.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 26/12/25.
//

import Foundation

// Fetches pokemon details through repository
final class FetchPokemonDetailUseCase: Sendable {
    private let repository: PokemonRepositoryProtocol
    
    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(pokemonID: Int) async throws -> PokemonDetail {
        try await repository.fetchPokemonDetail(id: pokemonID)
    }
}
