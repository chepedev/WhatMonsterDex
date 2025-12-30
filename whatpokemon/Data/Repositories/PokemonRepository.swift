//
//  PokemonRepository.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 27/12/25.
//

import Foundation

/// Returns cached data immediately when available, then refreshes in background.
final class PokemonRepository: PokemonRepositoryProtocol {
    private let httpClient: HTTPClient
    private let dataActor: PokemonDataActor
    
    init(httpClient: HTTPClient, dataActor: PokemonDataActor, mapper: PokemonMapper) {
        self.httpClient = httpClient
        self.dataActor = dataActor
    }
    

    /// Returns cached data immediately if available, then updates cache in background.
    /// Falls back to network-only fetch if no cache exists.
    func fetchPokemonList(offset: Int, limit: Int) async throws -> [Pokemon] {
        let cached = try? await dataActor.fetchPokemonEntities(offset: offset, limit: limit)
        
        if let cached = cached, !cached.isEmpty {
            let dataActor = self.dataActor
            let httpClient = self.httpClient
            
            Task.detached {
                try? await Self.refreshInBackground(
                    offset: offset,
                    limit: limit,
                    httpClient: httpClient,
                    dataActor: dataActor
                )
            }
            return cached
        }
        
        // No cache available, perform synchronous network fetch
        return try await refreshPokemonList(offset: offset, limit: limit)
    }
    
    // Fetch from network and save to cache (used when no cache available)
    private func refreshPokemonList(offset: Int, limit: Int) async throws -> [Pokemon] {
        let endpoint = PokemonEndpoint.list(offset: offset, limit: limit)
        let dto: PokemonListResponseDTO = try await httpClient.request(endpoint)
        
        try await dataActor.savePokemonFromDTOs(dto.results, offset: offset)
        
        return try await dataActor.fetchPokemonEntities(offset: offset, limit: limit)
    }
    
    // Static to avoid self capture in Task.detached - just updates cache silently
    private static func refreshInBackground(
        offset: Int,
        limit: Int,
        httpClient: HTTPClient,
        dataActor: PokemonDataActor
    ) async throws {
        let endpoint = PokemonEndpoint.list(offset: offset, limit: limit)
        let dto: PokemonListResponseDTO = try await httpClient.request(endpoint)
        try await dataActor.savePokemonFromDTOs(dto.results, offset: offset)
    }
    
    // Called when tapping a pokemon - shows detail screen
    func fetchPokemonDetail(id: Int) async throws -> PokemonDetail {
        let cached = try? await dataActor.fetchPokemonDetailEntity(id: id)
        
        if let cached = cached {
            let dataActor = self.dataActor
            let httpClient = self.httpClient
            Task.detached {
                try? await Self.refreshDetailInBackground(
                    id: id,
                    httpClient: httpClient,
                    dataActor: dataActor
                )
            }
            return cached
        }
        
        return try await refreshPokemonDetail(id: id)
    }
    
    // Fetch detail from API and save it
    private func refreshPokemonDetail(id: Int) async throws -> PokemonDetail {
        let endpoint = PokemonEndpoint.detail(id: id)
        let dto: PokemonDetailDTO = try await httpClient.request(endpoint)
        
        return try await dataActor.savePokemonDetailAndReturn(dto: dto)
    }
    
    private static func refreshDetailInBackground(
        id: Int,
        httpClient: HTTPClient,
        dataActor: PokemonDataActor
    ) async throws {
        let endpoint = PokemonEndpoint.detail(id: id)
        let dto: PokemonDetailDTO = try await httpClient.request(endpoint)
        _ = try await dataActor.savePokemonDetailAndReturn(dto: dto)
    }
    
    func toggleFavorite(id: Int) async -> Bool {
        await FavoritesManager.shared.toggleFavorite(id)
    }
    
    func isFavorite(id: Int) async -> Bool {
        await FavoritesManager.shared.isFavorite(id)
    }
    
    // Loads all favorite pokemon
    func getFavorites() async -> [Pokemon] {
        let favoriteIDs = await FavoritesManager.shared.getAllFavorites()
        
        guard !favoriteIDs.isEmpty else {
            return []
        }
        
        do {
            return try await dataActor.fetchPokemonEntitiesByIDs(favoriteIDs)
        } catch {
            print("Failed to fetch favorites: \(error.localizedDescription)")
            return []
        }
    }
    
    // Shows how many pokemon are stored offline (for Info screen)
    func getCachedPokemonCount() async -> Int {
        do {
            return try await dataActor.getPokemonCount()
        } catch {
            print("Failed to get Pokemon count: \(error.localizedDescription)")
            return 0
        }
    }
}
