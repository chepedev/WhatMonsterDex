//
//  PokemonEndpoint.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 26/12/25.
//

import Foundation

// All the PokeAPI endpoints we use (list and details endpoints)
enum PokemonEndpoint: Endpoint {
    case list(offset: Int, limit: Int)
    case detail(id: Int)
    
    var baseURL: String {
        "https://pokeapi.co/api/v2"
    }
    
    var path: String {
        switch self {
        case .list:
            return "/pokemon"
        case .detail(let id):
            return "/pokemon/\(id)"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .list(let offset, let limit):
            return [
                URLQueryItem(name: "offset", value: "\(offset)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        case .detail:
            return nil
        }
    }
    
    var headers: [String: String]? {
        ["Accept": "application/json"]
    }
}
