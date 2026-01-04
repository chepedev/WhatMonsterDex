//
//  PreviewHelpers.swift
//  WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 4/1/26.
//

import Foundation
import SwiftData

/// Shared preview model container for SwiftUI previews
/// This keeps SwiftData imports isolated from the presentation layer
final class PreviewModelContainer {
    static let shared: ModelContainer = {
        let schema = Schema([
            PokemonPersistentModel.self,
            PokemonDetailPersistentModel.self
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        
        do {
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Failed to create preview model container: \(error)")
        }
    }()
}

/// Shared preview dependency container for SwiftUI previews
final class PreviewDependencyContainer {
    static let shared = DependencyContainer(modelContainer: PreviewModelContainer.shared)
}
