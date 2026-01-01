//
//  PokemonDetailPersistentModel.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 26/12/25.
//

import Foundation
import SwiftData

// SwiftData model for storing pokemons details locally
@Model
final class PokemonDetailPersistentModel {
    @Attribute(.unique) var id: Int
    var name: String
    var height: Int
    var weight: Int
    var statsJSON: String
    var typesJSON: String
    var spritesJSON: String
    var fetchedAt: Date
    
    init(id: Int, name: String, height: Int, weight: Int,
         statsJSON: String, typesJSON: String, spritesJSON: String) {
        self.id = id
        self.name = name
        self.height = height
        self.weight = weight
        self.statsJSON = statsJSON
        self.typesJSON = typesJSON
        self.spritesJSON = spritesJSON
        self.fetchedAt = Date()
    }
}
