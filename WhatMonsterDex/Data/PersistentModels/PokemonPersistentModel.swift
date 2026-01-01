//
//  PokemonPersistentModel.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 26/12/25.
//

import Foundation
import SwiftData

// SwiftData model for caching pokemon list locally
@Model
final class PokemonPersistentModel {
    @Attribute(.unique) var id: Int
    var name: String
    var spriteURLString: String?
    var typesJSON: String // Store as JSON array for simplicity for now.
    var offset: Int // tracks which page this Pokemon belongs to
    var fetchedAt: Date
    
    init(id: Int, name: String, spriteURLString: String?, typesJSON: String, offset: Int) {
        self.id = id
        self.name = name
        self.spriteURLString = spriteURLString
        self.typesJSON = typesJSON
        self.offset = offset
        self.fetchedAt = Date()
    }
}
