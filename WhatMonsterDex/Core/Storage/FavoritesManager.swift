//
//  FavoritesManager.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 29/12/25.
//

import Foundation

// Manages starred Pokemon (saves to UserDefaults)
@globalActor
actor FavoritesManager {
    static let shared = FavoritesManager()
    
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "favoritePokemonIDs"
    
    private var favoriteIDs: Set<Int>
    
    private init() {
        // Load favorites synchronously in init
        if let data = UserDefaults.standard.array(forKey: "favoritePokemonIDs") as? [Int] {
            favoriteIDs = Set(data)
        } else {
            favoriteIDs = []
        }
    }
    
    func isFavorite(_ id: Int) -> Bool {
        favoriteIDs.contains(id)
    }
    
    @discardableResult
    func toggleFavorite(_ id: Int) -> Bool {
        if favoriteIDs.contains(id) {
            favoriteIDs.remove(id)
        } else {
            favoriteIDs.insert(id)
        }
        saveFavorites()
        return favoriteIDs.contains(id)
    }
    
    func getAllFavorites() -> [Int] {
        Array(favoriteIDs).sorted()
    }
    
    func removeFavorite(_ id: Int) {
        favoriteIDs.remove(id)
        saveFavorites()
    }
    
    func clearAll() {
        favoriteIDs.removeAll()
        saveFavorites()
    }
        
    private func saveFavorites() {
        userDefaults.set(Array(favoriteIDs), forKey: favoritesKey)
    }
}
