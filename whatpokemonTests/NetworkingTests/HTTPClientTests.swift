//
//  HTTPClientTests.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 27/12/25.
//

import Testing
import Foundation
@testable import whatpokemon

// Tests for HTTP client networking layer
@Suite("HTTPClient Tests")
@MainActor
struct HTTPClientTests {
    
    @Test("Successful request with valid response")
    func testSuccessfulRequest() async throws {
        // Arrange
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let client = URLSessionHTTPClient(session: session)
        
        let mockData = """
        {
            "count": 1,
            "next": null,
            "previous": null,
            "results": [
                {
                    "name": "bulbasaur",
                    "url": "https://pokeapi.co/api/v2/pokemon/1/"
                }
            ]
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, mockData)
        }
        
        // Act
        let endpoint = PokemonEndpoint.list(offset: 0, limit: 20)
        let result: PokemonListResponseDTO = try await client.request(endpoint)
        
        // Assert
        #expect(result.count == 1)
        #expect(result.results.count == 1)
        #expect(result.results[0].name == "bulbasaur")
    }
    // TODO: Add missing tests for: (404, 500, invalid JSON)

}
