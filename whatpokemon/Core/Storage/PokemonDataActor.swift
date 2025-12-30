//
//  PokemonDataActor.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 29/12/25.
//

import Foundation
import SwiftData

// Handles all database operations (saves pokemon, loads from cache etc)

@ModelActor
actor PokemonDataActor {
    
    // Loads pokemon for a specific page from local cache
    // Also includes favorite status for each pokemon
    func fetchPokemonEntities(offset: Int, limit: Int) async throws -> [Pokemon] {
        let descriptor = FetchDescriptor<PokemonPersistentModel>(
            predicate: #Predicate { pokemon in
                pokemon.offset >= offset && pokemon.offset < offset + limit
            },
            sortBy: [SortDescriptor(\.id)]
        )
        
        let models = try modelContext.fetch(descriptor)
        let mapper = PokemonMapper()
        let favoritesManager = FavoritesManager.shared
        
        // SwiftData models can't leave the actor, so we copy just the primitive values
        // then reconstruct clean Pokemon entities outside
        let modelData = models.map { (id: $0.id, name: $0.name, spriteURLString: $0.spriteURLString, typesJSON: $0.typesJSON) }
        
        var results: [Pokemon] = []
        for data in modelData {
            let isFavorite = await favoritesManager.isFavorite(data.id)
            
            let tempModel = PokemonPersistentModel(
                id: data.id,
                name: data.name,
                spriteURLString: data.spriteURLString,
                typesJSON: data.typesJSON,
                offset: offset
            )
            results.append(mapper.toEntity(from: tempModel, isFavorite: isFavorite))
        }
        
        return results
    }
    
    // Loads specific pokemon by their IDs, (Used for favorites screen)
    func fetchPokemonEntitiesByIDs(_ ids: [Int]) async throws -> [Pokemon] {
        let descriptor = FetchDescriptor<PokemonPersistentModel>(
            predicate: #Predicate { pokemon in
                ids.contains(pokemon.id)
            },
            sortBy: [SortDescriptor(\.id)]
        )
        
        let models = try modelContext.fetch(descriptor)
        let mapper = PokemonMapper()
        let favoritesManager = FavoritesManager.shared
        
        let modelData = models.map { (id: $0.id, name: $0.name, spriteURLString: $0.spriteURLString, typesJSON: $0.typesJSON, offset: $0.offset) }
        
        var results: [Pokemon] = []
        for data in modelData {
            let isFavorite = await favoritesManager.isFavorite(data.id)
            
            let tempModel = PokemonPersistentModel(
                id: data.id,
                name: data.name,
                spriteURLString: data.spriteURLString,
                typesJSON: data.typesJSON,
                offset: data.offset
            )
            results.append(mapper.toEntity(from: tempModel, isFavorite: isFavorite))
        }
        
        return results
    }
    
    // Saves pokemon from network response to local database
    func savePokemonFromDTOs(_ dtos: [PokemonResultDTO], offset: Int) throws {
        let mapper = PokemonMapper()
        let models = dtos.compactMap { mapper.toPersistentModel(from: $0, offset: offset) }
        
        for model in models {
            // doing an upsert - check if exists first then update or insert
            // prevents duplicates in database
            let modelID = model.id
            let descriptor = FetchDescriptor<PokemonPersistentModel>(
                predicate: #Predicate { $0.id == modelID }
            )
            
            let existing = try modelContext.fetch(descriptor).first
            
            if let existing = existing {
                existing.name = model.name
                existing.spriteURLString = model.spriteURLString
                existing.typesJSON = model.typesJSON
                existing.offset = model.offset
                existing.fetchedAt = model.fetchedAt
            } else {
                modelContext.insert(model)
            }
        }
        
        try modelContext.save()
    }
    
    // Wipes all cached pokemon data (for "Clear Cache" button)
    func clearAllData() throws {
        try modelContext.delete(model: PokemonPersistentModel.self)
        try modelContext.delete(model: PokemonDetailPersistentModel.self)
        try modelContext.save()
    }
    
    // Counts how many pokemon are saved offline
    func getPokemonCount() throws -> Int {
        let descriptor = FetchDescriptor<PokemonPersistentModel>()
        return try modelContext.fetchCount(descriptor)
    }
        
    // Loads pokemon details from local cache
    func fetchPokemonDetailEntity(id: Int) throws -> PokemonDetail? {
        let descriptor = FetchDescriptor<PokemonDetailPersistentModel>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let model = try modelContext.fetch(descriptor).first else {
            return nil
        }
        
        let mapper = PokemonMapper()
        return try mapper.toDetailEntity(from: model)
    }
    
    // Saves pokemon details from network and returns it ready to display
    func savePokemonDetailAndReturn(dto: PokemonDetailDTO) throws -> PokemonDetail {
        let mapper = PokemonMapper()
        let model = try mapper.toDetailPersistentModel(from: dto)
        
        let detailID = model.id
        let descriptor = FetchDescriptor<PokemonDetailPersistentModel>(
            predicate: #Predicate { $0.id == detailID }
        )
        
        let existing = try modelContext.fetch(descriptor).first
        
        if let existing = existing {
            existing.name = model.name
            existing.height = model.height
            existing.weight = model.weight
            existing.statsJSON = model.statsJSON
            existing.typesJSON = model.typesJSON
            existing.spritesJSON = model.spritesJSON
            existing.fetchedAt = model.fetchedAt
        } else {
            modelContext.insert(model)
        }
        
        try modelContext.save()
        return try mapper.toDetailEntity(from: model)
    }
}
