//
//  PokemonDTOTests.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 27/12/25.
//

import Testing
import Foundation
@testable import whatpokemon

@Suite("PokemonDTO Tests")
@MainActor
struct PokemonDTOTests {
    
    @Test("Decode PokemonListResponseDTO from JSON")
    func testDecodePokemonListResponse() throws {
        // Arrange
        let json = """
        {
            "count": 1302,
            "next": "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
            "previous": null,
            "results": [
                {
                    "name": "bulbasaur",
                    "url": "https://pokeapi.co/api/v2/pokemon/1/"
                },
                {
                    "name": "ivysaur",
                    "url": "https://pokeapi.co/api/v2/pokemon/2/"
                }
            ]
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Act
        let dto = try decoder.decode(PokemonListResponseDTO.self, from: data)
        
        // Assert
        #expect(dto.count == 1302)
        #expect(dto.next != nil)
        #expect(dto.previous == nil)
        #expect(dto.results.count == 2)
        #expect(dto.results[0].name == "bulbasaur")
        #expect(dto.results[1].name == "ivysaur")
    }
    
    @Test("Extract Pokemon ID from URL")
    func testExtractPokemonID() {
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
    
    @Test("Extract Pokemon ID from different URL formats")
    func testExtractIDFromVariousURLs() {
        let testCases: [(url: String, expectedID: Int?)] = [
            ("https://pokeapi.co/api/v2/pokemon/1/", 1),
            ("https://pokeapi.co/api/v2/pokemon/150/", 150),
            ("https://pokeapi.co/api/v2/pokemon/898/", 898),
            ("invalid-url", nil)
        ]
        
        for testCase in testCases {
            // Arrange
            let dto = PokemonResultDTO(name: "test", url: testCase.url)
            
            // Act
            let id = dto.extractedID
            
            // Assert
            #expect(id == testCase.expectedID)
        }
    }
    
    @Test("Construct sprite URL from Pokemon ID")
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
        #expect(spriteURL?.absoluteString.contains("sprites/pokemon/6.png") == true)
    }
    
    @Test("Decode PokemonDetailDTO from JSON")
    func testDecodePokemonDetail() throws {
        // Arrange
        let json = """
        {
            "id": 1,
            "name": "bulbasaur",
            "height": 7,
            "weight": 69,
            "stats": [
                {
                    "base_stat": 45,
                    "effort": 0,
                    "stat": {
                        "name": "hp",
                        "url": "https://pokeapi.co/api/v2/stat/1/"
                    }
                }
            ],
            "types": [
                {
                    "slot": 1,
                    "type": {
                        "name": "grass",
                        "url": "https://pokeapi.co/api/v2/type/12/"
                    }
                }
            ],
            "sprites": {
                "front_default": "https://example.com/1.png",
                "front_shiny": null,
                "back_default": null,
                "back_shiny": null
            }
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Act
        let dto = try decoder.decode(PokemonDetailDTO.self, from: data)
        
        // Assert
        #expect(dto.id == 1)
        #expect(dto.name == "bulbasaur")
        #expect(dto.height == 7)
        #expect(dto.weight == 69)
        #expect(dto.stats.count == 1)
        #expect(dto.types.count == 1)
        #expect(dto.sprites.frontDefault != nil)
    }
    
    @Test("Decode PokemonDetailDTO with all stats")
    func testDecodePokemonDetailWithAllStats() throws {
        // Arrange
        let json = """
        {
            "id": 1,
            "name": "bulbasaur",
            "height": 7,
            "weight": 69,
            "stats": [
                {"base_stat": 45, "effort": 0, "stat": {"name": "hp", "url": "https://pokeapi.co/api/v2/stat/1/"}},
                {"base_stat": 49, "effort": 0, "stat": {"name": "attack", "url": "https://pokeapi.co/api/v2/stat/2/"}},
                {"base_stat": 49, "effort": 0, "stat": {"name": "defense", "url": "https://pokeapi.co/api/v2/stat/3/"}},
                {"base_stat": 65, "effort": 1, "stat": {"name": "special-attack", "url": "https://pokeapi.co/api/v2/stat/4/"}},
                {"base_stat": 65, "effort": 0, "stat": {"name": "special-defense", "url": "https://pokeapi.co/api/v2/stat/5/"}},
                {"base_stat": 45, "effort": 0, "stat": {"name": "speed", "url": "https://pokeapi.co/api/v2/stat/6/"}}
            ],
            "types": [],
            "sprites": {
                "front_default": null,
                "front_shiny": null,
                "back_default": null,
                "back_shiny": null
            }
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Act
        let dto = try decoder.decode(PokemonDetailDTO.self, from: data)
        
        // Assert
        #expect(dto.stats.count == 6)
        #expect(dto.stats[0].stat.name == "hp")
        #expect(dto.stats[0].baseStat == 45)
    }
    
    @Test("Decode PokemonDetailDTO with multiple types")
    func testDecodePokemonDetailWithMultipleTypes() throws {
        // Arrange
        let json = """
        {
            "id": 1,
            "name": "bulbasaur",
            "height": 7,
            "weight": 69,
            "stats": [],
            "types": [
                {"slot": 1, "type": {"name": "grass", "url": "https://pokeapi.co/api/v2/type/12/"}},
                {"slot": 2, "type": {"name": "poison", "url": "https://pokeapi.co/api/v2/type/4/"}}
            ],
            "sprites": {
                "front_default": null,
                "front_shiny": null,
                "back_default": null,
                "back_shiny": null
            }
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Act
        let dto = try decoder.decode(PokemonDetailDTO.self, from: data)
        
        // Assert
        #expect(dto.types.count == 2)
        #expect(dto.types[0].type.name == "grass")
        #expect(dto.types[1].type.name == "poison")
    }
}
