//
//  PokemonDetailViewModel.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 29/12/25.
//

import Foundation
import Observation

@MainActor
@Observable
final class PokemonDetailViewModel {
    // MARK: State
    
    private(set) var pokemonDetail: PokemonDetail?
    private(set) var isLoading = false
    private(set) var error: Error?
    var isFavorite = false
    
    private let pokemonID: Int
    private let useCase: FetchPokemonDetailUseCase
    private let repository: PokemonRepositoryProtocol
    private var loadTask: Task<Void, Never>?
    
    // MARK: - Initialization
    
    init(pokemonID: Int, useCase: FetchPokemonDetailUseCase, repository: PokemonRepositoryProtocol) {
        self.pokemonID = pokemonID
        self.useCase = useCase
        self.repository = repository
    }
    
    // MARK: - Public Methods
    
    func loadDetail() {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        loadTask = Task {
            isFavorite = await repository.isFavorite(id: pokemonID)
            
            do {
                pokemonDetail = try await useCase.execute(pokemonID: pokemonID)
                error = nil
            } catch let loadError {
                if pokemonDetail == nil {
                    error = loadError
                }
            }
            
            isLoading = false
        }
    }
    
    func toggleFavorite() {
        Task {
            isFavorite = await repository.toggleFavorite(id: pokemonID)
        }
    }
    
    func retry() {
        loadDetail()
    }
}
