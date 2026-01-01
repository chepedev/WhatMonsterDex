//
//  Endpoint.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 26/12/25.
//

import Foundation

// Defines how to build API requests - URL, method, headers etc
protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    
    func makeRequest() throws -> URLRequest
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension Endpoint {
    func makeRequest() throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
