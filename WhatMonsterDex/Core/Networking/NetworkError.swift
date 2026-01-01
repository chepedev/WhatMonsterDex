//
//  NetworkError.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 26/12/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case noInternetConnection
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .noInternetConnection:
            return "No internet connection"
        }
    }
}
