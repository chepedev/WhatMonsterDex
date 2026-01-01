//
//  PokemonDetailMapperTests.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 27/12/25.
//

import Testing
import Foundation
@testable import WhatMonsterDex

@Suite("PokemonDetail Mapper Tests")
@MainActor
struct PokemonDetailMapperTests {
    let mapper = PokemonMapper()
    
    @Test("Map PokemonDetailDTO to PersistentModel")
    func testMapDetailDTOToPersistentModel() throws {
        // Arrange
        let dto = PokemonDetailDTO(
            id: 1,
            name: "bulbasaur",
            height: 7,
            weight: 69,
            stats: [
                StatDTO(
                    baseStat: 45,
                    effort: 0,
                    stat: NamedResourceDTO(name: "hp", url: "")
                )
            ],
            types: [
                TypeSlotDTO(
                    slot: 1,
                    type: NamedResourceDTO(name: "grass", url: "")
                )
            ],
            sprites: SpritesDTO(
                frontDefault: "https://example.com/1.png",
                frontShiny: nil,
                backDefault: nil,
                backShiny: nil
            )
        )
        
        // Act
        let model = try mapper.toDetailPersistentModel(from: dto)
        
        // Assert
        #expect(model.id == 1)
        #expect(model.name == "bulbasaur")
        #expect(model.height == 7)
        #expect(model.weight == 69)
        #expect(!model.statsJSON.isEmpty)
        #expect(!model.typesJSON.isEmpty)
        #expect(!model.spritesJSON.isEmpty)
    }
    
    @Test("Map PokemonDetailPersistentModel to Entity")
    func testMapDetailPersistentModelToEntity() throws {
        // Arrange
        let statsJSON = """
        [{"name":"hp","baseStat":45,"effort":0}]
        """
        let typesJSON = """
        [{"name":"grass"}]
        """
        let spritesJSON = """
        {"frontDefault":"https://example.com/1.png","frontShiny":null,"backDefault":null,"backShiny":null}
        """
        
        let model = PokemonDetailPersistentModel(
            id: 1,
            name: "bulbasaur",
            height: 7,
            weight: 69,
            statsJSON: statsJSON,
            typesJSON: typesJSON,
            spritesJSON: spritesJSON
        )
        
        // Act
        let entity = try mapper.toDetailEntity(from: model)
        
        // Assert
        #expect(entity.id == 1)
        #expect(entity.name == "bulbasaur")
        #expect(entity.height == 7)
        #expect(entity.weight == 69)
        #expect(entity.stats.count == 1)
        #expect(entity.types.count == 1)
        #expect(entity.sprites.frontDefault != nil)
    }
    
    @Test("Map DTO with multiple stats")
    func testMapDTOWithMultipleStats() throws {
        // Arrange
        let dto = PokemonDetailDTO(
            id: 1,
            name: "bulbasaur",
            height: 7,
            weight: 69,
            stats: [
                StatDTO(baseStat: 45, effort: 0, stat: NamedResourceDTO(name: "hp", url: "")),
                StatDTO(baseStat: 49, effort: 0, stat: NamedResourceDTO(name: "attack", url: "")),
                StatDTO(baseStat: 49, effort: 0, stat: NamedResourceDTO(name: "defense", url: "")),
                StatDTO(baseStat: 65, effort: 1, stat: NamedResourceDTO(name: "special-attack", url: "")),
                StatDTO(baseStat: 65, effort: 0, stat: NamedResourceDTO(name: "special-defense", url: "")),
                StatDTO(baseStat: 45, effort: 0, stat: NamedResourceDTO(name: "speed", url: ""))
            ],
            types: [],
            sprites: SpritesDTO(frontDefault: nil, frontShiny: nil, backDefault: nil, backShiny: nil)
        )
        
        // Act
        let model = try mapper.toDetailPersistentModel(from: dto)
        let entity = try mapper.toDetailEntity(from: model)
        
        // Assert
        #expect(entity.stats.count == 6)
        #expect(entity.stats[0].name == "hp")
        #expect(entity.stats[0].baseStat == 45)
    }
    
    @Test("Map DTO with multiple types")
    func testMapDTOWithMultipleTypes() throws {
        // Arrange
        let dto = PokemonDetailDTO(
            id: 1,
            name: "bulbasaur",
            height: 7,
            weight: 69,
            stats: [],
            types: [
                TypeSlotDTO(slot: 1, type: NamedResourceDTO(name: "grass", url: "")),
                TypeSlotDTO(slot: 2, type: NamedResourceDTO(name: "poison", url: ""))
            ],
            sprites: SpritesDTO(frontDefault: nil, frontShiny: nil, backDefault: nil, backShiny: nil)
        )
        
        // Act
        let model = try mapper.toDetailPersistentModel(from: dto)
        let entity = try mapper.toDetailEntity(from: model)
        
        // Assert
        #expect(entity.types.count == 2)
        #expect(entity.types[0].name == "grass")
        #expect(entity.types[1].name == "poison")
    }
    
    @Test("Map DTO with all sprite URLs")
    func testMapDTOWithAllSprites() throws {
        // Arrange
        let dto = PokemonDetailDTO(
            id: 1,
            name: "bulbasaur",
            height: 7,
            weight: 69,
            stats: [],
            types: [],
            sprites: SpritesDTO(
                frontDefault: "https://example.com/front.png",
                frontShiny: "https://example.com/shiny.png",
                backDefault: "https://example.com/back.png",
                backShiny: "https://example.com/back-shiny.png"
            )
        )
        
        // Act
        let model = try mapper.toDetailPersistentModel(from: dto)
        let entity = try mapper.toDetailEntity(from: model)
        
        // Assert
        #expect(entity.sprites.frontDefault != nil)
        #expect(entity.sprites.frontShiny != nil)
        #expect(entity.sprites.backDefault != nil)
        #expect(entity.sprites.backShiny != nil)
    }
    
    @Test("Height and weight conversions")
    func testHeightWeightConversions() throws {
        // Arrange
        let dto = PokemonDetailDTO(
            id: 1,
            name: "bulbasaur",
            height: 7,  // 0.7 meters
            weight: 69, // 6.9 kg
            stats: [],
            types: [],
            sprites: SpritesDTO(frontDefault: nil, frontShiny: nil, backDefault: nil, backShiny: nil)
        )
        
        // Act
        let model = try mapper.toDetailPersistentModel(from: dto)
        let entity = try mapper.toDetailEntity(from: model)
        
        // Assert
        #expect(entity.heightInMeters == 0.7)
        #expect(entity.weightInKilograms == 6.9)
    }
}
