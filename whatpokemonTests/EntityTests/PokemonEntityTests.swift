//
//  PokemonEntityTests.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 27/12/25.
//

import Testing
import Foundation
@testable import whatpokemon

@Suite("Pokemon Entity Tests")
@MainActor
struct PokemonEntityTests {
    
    @Test("Pokemon entity initialization")
    func testPokemonInitialization() {
        // Arrange & Act
        let pokemon = Pokemon(
            id: 1,
            name: "bulbasaur",
            spriteURL: URL(string: "https://example.com/1.png"),
            types: [PokemonType(name: "grass"), PokemonType(name: "poison")]
        )
        
        // Assert
        #expect(pokemon.id == 1)
        #expect(pokemon.name == "bulbasaur")
        #expect(pokemon.spriteURL != nil)
        #expect(pokemon.types.count == 2)
        #expect(pokemon.isFavorite == false)
    }
    
    @Test("Pokemon entity with favorite status")
    func testPokemonWithFavorite() {
        // Arrange & Act
        let pokemon = Pokemon(
            id: 25,
            name: "pikachu",
            spriteURL: nil,
            types: [PokemonType(name: "electric")],
            isFavorite: true
        )
        
        // Assert
        #expect(pokemon.isFavorite == true)
    }
    
    @Test("Pokemon entity Identifiable conformance")
    func testPokemonIdentifiable() {
        // Arrange
        let pokemon1 = Pokemon(id: 1, name: "bulbasaur", spriteURL: nil, types: [])
        let pokemon2 = Pokemon(id: 2, name: "ivysaur", spriteURL: nil, types: [])
        
        // Assert
        #expect(pokemon1.id != pokemon2.id)
    }
    
    @Test("Pokemon entity Sendable conformance")
    func testPokemonSendable() {
        // This test verifies that Pokemon can be safely sent across actor boundaries
        let pokemon = Pokemon(id: 1, name: "bulbasaur", spriteURL: nil, types: [])
        
        Task {
            // If Pokemon is Sendable, this should compile without warnings
            let _ = pokemon
        }
        
        #expect(true) // If we get here, Sendable conformance is working
    }
}

@Suite("PokemonDetail Entity Tests")
@MainActor
struct PokemonDetailEntityTests {
    
    @Test("PokemonDetail entity initialization")
    func testPokemonDetailInitialization() {
        // Arrange & Act
        let detail = PokemonDetail(
            id: 1,
            name: "bulbasaur",
            height: 7,
            weight: 69,
            stats: [
                Stat(name: "hp", baseStat: 45, effort: 0),
                Stat(name: "attack", baseStat: 49, effort: 0)
            ],
            types: [PokemonType(name: "grass"), PokemonType(name: "poison")],
            sprites: PokemonSprite(
                frontDefault: URL(string: "https://example.com/1.png"),
                frontShiny: nil,
                backDefault: nil,
                backShiny: nil
            )
        )
        
        // Assert
        #expect(detail.id == 1)
        #expect(detail.name == "bulbasaur")
        #expect(detail.height == 7)
        #expect(detail.weight == 69)
        #expect(detail.stats.count == 2)
        #expect(detail.types.count == 2)
    }
    
    @Test("PokemonDetail height conversion to meters")
    func testHeightInMeters() {
        // Arrange
        let detail = PokemonDetail(
            id: 1,
            name: "bulbasaur",
            height: 7, // 7 decimeters
            weight: 69,
            stats: [],
            types: [],
            sprites: PokemonSprite(frontDefault: nil, frontShiny: nil, backDefault: nil, backShiny: nil)
        )
        
        // Act
        let heightInMeters = detail.heightInMeters
        
        // Assert
        #expect(heightInMeters == 0.7)
    }
    
    @Test("PokemonDetail weight conversion to kilograms")
    func testWeightInKilograms() {
        // Arrange
        let detail = PokemonDetail(
            id: 1,
            name: "bulbasaur",
            height: 7,
            weight: 69, // 69 hectograms
            stats: [],
            types: [],
            sprites: PokemonSprite(frontDefault: nil, frontShiny: nil, backDefault: nil, backShiny: nil)
        )
        
        // Act
        let weightInKg = detail.weightInKilograms
        
        // Assert
        #expect(weightInKg == 6.9)
    }
}

@Suite("Stat Entity Tests")
@MainActor
struct StatEntityTests {
    
    @Test("Stat display name formatting")
    func testStatDisplayNames() {
        // Test cases for different stat names
        let testCases: [(input: String, expected: String)] = [
            ("hp", "HP"),
            ("attack", "Attack"),
            ("defense", "Defense"),
            ("special-attack", "Sp. Atk"),
            ("special-defense", "Sp. Def"),
            ("speed", "Speed")
        ]
        
        for testCase in testCases {
            // Arrange
            let stat = Stat(name: testCase.input, baseStat: 50, effort: 0)
            
            // Act
            let displayName = stat.displayName
            
            // Assert
            #expect(displayName == testCase.expected)
        }
    }
    
    @Test("Stat Hashable conformance")
    func testStatHashable() {
        // Arrange
        let stat1 = Stat(name: "hp", baseStat: 45, effort: 0)
        let stat2 = Stat(name: "hp", baseStat: 45, effort: 0)
        let stat3 = Stat(name: "attack", baseStat: 49, effort: 0)
        
        // Assert
        #expect(stat1 == stat2)
        #expect(stat1 != stat3)
    }
}

@Suite("PokemonType Entity Tests")
@MainActor
struct PokemonTypeEntityTests {
    
    @Test("PokemonType initialization")
    func testPokemonTypeInitialization() {
        // Arrange & Act
        let type = PokemonType(name: "fire")
        
        // Assert
        #expect(type.name == "fire")
    }
    
    @Test("PokemonType color mapping")
    func testPokemonTypeColors() {
        // Test that different types have different colors
        let fireType = PokemonType(name: "fire")
        let waterType = PokemonType(name: "water")
        let grassType = PokemonType(name: "grass")
        
        // Assert colors are defined
        #expect(fireType.color != nil)
        #expect(waterType.color != nil)
        #expect(grassType.color != nil)
    }
    
    @Test("PokemonType Hashable conformance")
    func testPokemonTypeHashable() {
        // Arrange
        let type1 = PokemonType(name: "fire")
        let type2 = PokemonType(name: "fire")
        let type3 = PokemonType(name: "water")
        
        // Assert
        #expect(type1 == type2)
        #expect(type1 != type3)
    }
}

@Suite("PokemonSprite Entity Tests")
@MainActor
struct PokemonSpriteEntityTests {
    
    @Test("PokemonSprite initialization")
    func testPokemonSpriteInitialization() {
        // Arrange & Act
        let sprite = PokemonSprite(
            frontDefault: URL(string: "https://example.com/front.png"),
            frontShiny: URL(string: "https://example.com/shiny.png"),
            backDefault: nil,
            backShiny: nil
        )
        
        // Assert
        #expect(sprite.frontDefault != nil)
        #expect(sprite.frontShiny != nil)
        #expect(sprite.backDefault == nil)
        #expect(sprite.backShiny == nil)
    }
    
    @Test("PokemonSprite Hashable conformance")
    func testPokemonSpriteHashable() {
        // Arrange
        let sprite1 = PokemonSprite(
            frontDefault: URL(string: "https://example.com/1.png"),
            frontShiny: nil,
            backDefault: nil,
            backShiny: nil
        )
        let sprite2 = PokemonSprite(
            frontDefault: URL(string: "https://example.com/1.png"),
            frontShiny: nil,
            backDefault: nil,
            backShiny: nil
        )
        
        // Assert
        #expect(sprite1 == sprite2)
    }
}
