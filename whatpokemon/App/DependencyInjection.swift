//
//  DependencyInjection.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 26/12/25.
//

import Foundation
import SwiftData
import Kingfisher

final class DependencyContainer {
    private let modelContainer: ModelContainer
    private let httpClient: HTTPClient
    private let dataActor: PokemonDataActor
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.httpClient = URLSessionHTTPClient()
        self.dataActor = PokemonDataActor(modelContainer: modelContainer)
        
        configureKingfisher()
    }
    
    func makePokemonListViewModel() -> PokemonListViewModel {
        let repository = PokemonRepository(
            httpClient: httpClient,
            dataActor: dataActor,
            mapper: PokemonMapper()
        )
        let useCase = FetchPokemonListUseCase(repository: repository)
        return PokemonListViewModel(useCase: useCase, repository: repository)
    }
    
    func makePokemonDetailViewModel(pokemonID: Int) -> PokemonDetailViewModel {
        let repository = PokemonRepository(
            httpClient: httpClient,
            dataActor: dataActor,
            mapper: PokemonMapper()
        )
        let useCase = FetchPokemonDetailUseCase(repository: repository)
        return PokemonDetailViewModel(pokemonID: pokemonID, useCase: useCase, repository: repository)
    }
    
    func makeFavoritesViewModel() -> FavoritesViewModel {
        let repository = PokemonRepository(
            httpClient: httpClient,
            dataActor: dataActor,
            mapper: PokemonMapper()
        )
        return FavoritesViewModel(repository: repository)
    }
    
    func makeInfoViewModel() -> InfoViewModel {
        return InfoViewModel(dataActor: dataActor)
    }
    
    // Image caching setup - never expire disk cache, 500MB limit
    private func configureKingfisher() {
        let cache = ImageCache.default
        
        // Never expire disk cache for offline support
        cache.diskStorage.config.expiration = .never
        
        // Set generous disk cache size (500 MB)
        cache.diskStorage.config.sizeLimit = 500 * 1024 * 1024
        
        // Memory cache expires after 10 minutes
        cache.memoryStorage.config.expiration = .seconds(600)
        
        // Enable background decode for better performance
        KingfisherManager.shared.defaultOptions = [
            .backgroundDecode,
            .cacheOriginalImage,
            .waitForCache
        ]
    }
}
