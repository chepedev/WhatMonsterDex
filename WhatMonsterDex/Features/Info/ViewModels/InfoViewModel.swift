//
//  InfoViewModel.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 30/12/25.
//

import Foundation
import Observation
import SwiftData
import Kingfisher

@MainActor
@Observable
final class InfoViewModel {

    private(set) var storageSize: String = "Calculating..."
    private(set) var pokemonCount: Int = 0
    private let dataActor: PokemonDataActor
        
    init(dataActor: PokemonDataActor) {
        self.dataActor = dataActor
    }
    
    
    func calculateStorageSize() {
        Task {
            do {
                // Get count of cached Pokemon
                let count = try await dataActor.getPokemonCount()
                pokemonCount = count
                
                // Calculate approximate storage size
                // Each Pokemon is roughly 1-2 KB, images are cached separately by kingfisher
                let approximateSize = count * 1500 // 1.5 KB per pokemon average
                storageSize = formatBytes(approximateSize)
                
            } catch {
                storageSize = "Unknown"
                pokemonCount = 0
            }
        }
    }
    
    func clearAllData() {
        Task {
            do {
                try await dataActor.clearAllData()
                await FavoritesManager.shared.clearAll()
                
                // Clear Kingfisher image cache
                await clearImageCache()
                
                // recalculate storage
                calculateStorageSize()
                
            } catch {
                print("Error clearing data: \(error)")
            }
        }
    }
    
    private func formatBytes(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
    
    private func clearImageCache() async {
        await MainActor.run {
            // Clear Kingfisher cache
            KingfisherManager.shared.cache.clearMemoryCache()
            KingfisherManager.shared.cache.clearDiskCache()
        }
    }
}
