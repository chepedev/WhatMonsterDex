//
//  PokemonMapperTests.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 30/12/25.
//

import Foundation
import Testing
@testable import whatpokemon

@Suite("PokemonMapper Tests")
struct PokemonMapperTests {
    let mapper = PokemonMapper()
    
    @Test("Map PokemonResultDTO to PersistentModel")
    func testMapDTOToPersistentModel() {
        // Arrange
        let dto = PokemonResultDTO(
            name: "bulbasaur",
            url: "https://pokeapi.co/api/v2/pokemon/1/"
        )
        
        // Act
        let model = mapper.toPersistentModel(from: dto, offset: 0)
        
        // Assert
        #expect(model != nil)
        #expect(model?.id == 1)
        #expect(model?.name == "bulbasaur")
        #expect(model?.spriteURLString != nil)
        #expect(model?.offset == 0)
    }
    
    @Test("Extract ID from Pokemon URL")
    func testExtractIDFromURL() {
        // Arrange
        let dto = PokemonResultDTO(
            name: "pikachu",
            url: "https://pokeapi.co/api/v2/pokemon/25/"
        )
        
        // Act
        let id = dto.extractedID
        
        // Assert
        #expect(id == 25)
    }
    
    @Test("Construct sprite URL from ID")
    @MainActor
    func testConstructSpriteURL() {
        // Arrange
        let dto = PokemonResultDTO(
            name: "charizard",
            url: "https://pokeapi.co/api/v2/pokemon/6/"
        )
        
        // Act
        let spriteURL = dto.spriteURL
        
        // Assert
        #expect(spriteURL != nil)
        #expect(spriteURL?.absoluteString.contains("/6.png") == true)
    }
    
    @Test("Map PersistentModel to Entity")
    @MainActor
    func testMapPersistentModelToEntity() {
        // Arrange
        let model = PokemonPersistentModel(
            id: 1,
            name: "bulbasaur",
            spriteURLString: "https://example.com/1.png",
            typesJSON: "[]",
            offset: 0
        )
        
        // Act
        let entity = mapper.toEntity(from: model)
        
        // Assert
        #expect(entity.id == 1)
        #expect(entity.name == "bulbasaur")
        #expect(entity.spriteURL != nil)
        #expect(entity.types.isEmpty)
    }
}
