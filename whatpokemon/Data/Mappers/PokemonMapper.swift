//
//  PokemonMapper.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 26/12/25.
//

import Foundation

// Converts between API responses (DTOs), database models and app entities
struct PokemonMapper: Sendable {
    nonisolated init() {}
    
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()
    
    nonisolated func toPersistentModel(from dto: PokemonResultDTO, offset: Int) -> PokemonPersistentModel? {
        guard let id = dto.extractedID else { return nil }
        
        // For now, we don't have type info in list response
        // Types will be empty array, filled in when detail is fetched
        let typesJSON = "[]"
        
        return PokemonPersistentModel(
            id: id,
            name: dto.name,
            spriteURLString: dto.spriteURL?.absoluteString,
            typesJSON: typesJSON,
            offset: offset
        )
    }
    
    nonisolated func toDetailPersistentModel(from dto: PokemonDetailDTO) throws -> PokemonDetailPersistentModel {
        let stats = dto.stats.map { statDTO in
            Stat(
                name: statDTO.stat.name,
                baseStat: statDTO.baseStat,
                effort: statDTO.effort
            )
        }
        let statsJSON = try jsonEncoder.encode(stats)
        
        let types = dto.types.map { typeSlot in
            PokemonType(name: typeSlot.type.name)
        }
        let typesJSON = try jsonEncoder.encode(types)
        
        let spritesDict: [String: String?] = [
            "frontDefault": dto.sprites.frontDefault,
            "frontShiny": dto.sprites.frontShiny,
            "backDefault": dto.sprites.backDefault,
            "backShiny": dto.sprites.backShiny
        ]
        let spritesJSON = try jsonEncoder.encode(spritesDict)
        
        return PokemonDetailPersistentModel(
            id: dto.id,
            name: dto.name,
            height: dto.height,
            weight: dto.weight,
            statsJSON: String(data: statsJSON, encoding: .utf8)!,
            typesJSON: String(data: typesJSON, encoding: .utf8)!,
            spritesJSON: String(data: spritesJSON, encoding: .utf8)!
        )
    }

    
    nonisolated func toEntity(from model: PokemonPersistentModel, isFavorite: Bool = false) -> Pokemon {
        let types: [PokemonType]
        if let data = model.typesJSON.data(using: .utf8),
           let decoded = try? jsonDecoder.decode([PokemonType].self, from: data) {
            types = decoded
        } else {
            types = []
        }
        
        return Pokemon(
            id: model.id,
            name: model.name,
            spriteURL: model.spriteURLString.flatMap(URL.init),
            types: types,
            isFavorite: isFavorite
        )
    }
    
    nonisolated func toDetailEntity(from model: PokemonDetailPersistentModel) throws -> PokemonDetail {
        guard let statsData = model.statsJSON.data(using: .utf8),
              let typesData = model.typesJSON.data(using: .utf8),
              let spritesData = model.spritesJSON.data(using: .utf8) else {
            throw MapperError.invalidJSON
        }
        
        let stats = try jsonDecoder.decode([Stat].self, from: statsData)
        let types = try jsonDecoder.decode([PokemonType].self, from: typesData)
        let spritesDict = try jsonDecoder.decode([String: String?].self, from: spritesData)
        
        let sprites = PokemonSprite(
            frontDefault: spritesDict["frontDefault"]?.flatMap(URL.init) ?? nil,
            frontShiny: spritesDict["frontShiny"]?.flatMap(URL.init) ?? nil,
            backDefault: spritesDict["backDefault"]?.flatMap(URL.init) ?? nil,
            backShiny: spritesDict["backShiny"]?.flatMap(URL.init) ?? nil
        )
        
        return PokemonDetail(
            id: model.id,
            name: model.name,
            height: model.height,
            weight: model.weight,
            stats: stats,
            types: types,
            sprites: sprites
        )
    }
}

enum MapperError: Error {
    case invalidJSON
}
