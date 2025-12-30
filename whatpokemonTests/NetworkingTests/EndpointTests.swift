//
//  EndpointTests.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 27/12/25.
//

import Testing
import Foundation
@testable import whatpokemon

@Suite("Endpoint Tests")
@MainActor
struct EndpointTests {
    
    @Test("Pokemon list endpoint creates correct URL")
    func testListEndpointURL() throws {
        // Arrange
        let endpoint = PokemonEndpoint.list(offset: 0, limit: 20)
        
        // Act
        let request = try endpoint.makeRequest()
        
        // Assert
        #expect(request.url != nil)
        #expect(request.url?.absoluteString.contains("pokemon") == true)
        #expect(request.url?.absoluteString.contains("offset=0") == true)
        #expect(request.url?.absoluteString.contains("limit=20") == true)
        #expect(request.httpMethod == "GET")
    }
    
    @Test("Pokemon detail endpoint creates correct URL")
    func testDetailEndpointURL() throws {
        // Arrange
        let endpoint = PokemonEndpoint.detail(id: 25)
        
        // Act
        let request = try endpoint.makeRequest()
        
        // Assert
        #expect(request.url != nil)
        #expect(request.url?.absoluteString.contains("pokemon/25") == true)
        #expect(request.httpMethod == "GET")
    }
    
    @Test("List endpoint with different pagination values")
    func testListEndpointPagination() throws {
        // Test different offset and limit values
        let testCases = [
            (offset: 0, limit: 20),
            (offset: 20, limit: 20),
            (offset: 100, limit: 50),
            (offset: 500, limit: 100)
        ]
        
        for testCase in testCases {
            // Arrange
            let endpoint = PokemonEndpoint.list(offset: testCase.offset, limit: testCase.limit)
            
            // Act
            let request = try endpoint.makeRequest()
            
            // Assert
            #expect(request.url?.absoluteString.contains("offset=\(testCase.offset)") == true)
            #expect(request.url?.absoluteString.contains("limit=\(testCase.limit)") == true)
        }
    }
    
    @Test("Detail endpoint with different Pokemon IDs")
    func testDetailEndpointDifferentIDs() throws {
        // Test different Pokemon IDs
        let testIDs = [1, 25, 150, 493, 898]
        
        for id in testIDs {
            // Arrange
            let endpoint = PokemonEndpoint.detail(id: id)
            
            // Act
            let request = try endpoint.makeRequest()
            
            // Assert
            #expect(request.url?.absoluteString.contains("pokemon/\(id)") == true)
        }
    }
    
    @Test("Endpoint base URL is correct")
    func testEndpointBaseURL() throws {
        // Arrange
        let endpoint = PokemonEndpoint.list(offset: 0, limit: 20)
        
        // Act
        let request = try endpoint.makeRequest()
        
        // Assert
        #expect(request.url?.scheme == "https")
        #expect(request.url?.host == "pokeapi.co")
    }
    
    @Test("Endpoint HTTP method is GET")
    func testEndpointHTTPMethod() throws {
        // Test list endpoint
        let listEndpoint = PokemonEndpoint.list(offset: 0, limit: 20)
        let listRequest = try listEndpoint.makeRequest()
        #expect(listRequest.httpMethod == "GET")
        
        // Test detail endpoint
        let detailEndpoint = PokemonEndpoint.detail(id: 1)
        let detailRequest = try detailEndpoint.makeRequest()
        #expect(detailRequest.httpMethod == "GET")
    }
}
