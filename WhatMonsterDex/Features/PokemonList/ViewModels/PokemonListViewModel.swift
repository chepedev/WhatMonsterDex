//
//  PokemonListViewModel.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 28/12/25.
//

import Foundation
import Observation

/// ViewModel for Pokemon list view
/// Uses @Observable for fine-grained reactivity
/// @MainActor ensures all UI updates happen on main thread
@MainActor
@Observable
final class PokemonListViewModel {
    // MARK: - Published State
    
    private(set) var pokemon: [Pokemon] = []
    private(set) var isLoading = false
    private(set) var hasMorePages = true
    private(set) var toastMessage: String?
    private(set) var toastType: ToastType = .info
    private(set) var isDownloadingAll = false
    private(set) var downloadProgress: Double = 0.0
    private(set) var isDownloadComplete = false
    var searchText: String = "" {
        didSet {
            filterPokemon()
        }
    }
    
    // MARK: - Private State
    
    private var allPokemon: [Pokemon] = []
    private var currentOffset = 0
    private let pageSize = 50  // Increased from 20 to 50 for better caching
    private let useCase: FetchPokemonListUseCase
    private var loadTask: Task<Void, Never>?
    private let repository: PokemonRepositoryProtocol
    
    // MARK: - Initialization
    
    init(useCase: FetchPokemonListUseCase, repository: PokemonRepositoryProtocol) {
        self.useCase = useCase
        self.repository = repository
        
        // Check if we have a full download cached
        Task {
            await checkDownloadStatus()
        }
    }
    
    // MARK: - Public Methods
    
    /// Loads the next page of Pokemon
    func loadNextPage() {
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
        
        loadTask = Task {
            do {
                let newPokemon = try await useCase.execute(offset: currentOffset, limit: pageSize)
                handleSuccessfulLoad(newPokemon)
            } catch {
                handleLoadError(error)
            }
            
            isLoading = false
        }
    }
    
    /// Determines if more data should be loaded based on current item
    /// - Parameter currentItem: The Pokemon currently being displayed
    /// - Returns: True if more data should be loaded
    func shouldLoadMore(currentItem: Pokemon) -> Bool {
        guard let index = pokemon.firstIndex(where: { $0.id == currentItem.id }) else {
            return false
        }
        // Load when user is 5 items from the end
        return index >= pokemon.count - 5
    }
    
    /// Refreshes the list from the beginning
    func refresh() {
        loadTask?.cancel()
        pokemon = []
        allPokemon = []
        currentOffset = 0
        hasMorePages = true
        loadNextPage()
    }
    
    /// Dismisses the current toast message
    func dismissToast() {
        toastMessage = nil
    }
    
    /// Downloads all Pokémon in the background
    func downloadAllPokemon() {
        guard !isDownloadingAll else { return }
        
        Task {
            // Show appropriate message based on whether this is an update or initial download
            let isUpdate = isDownloadComplete
            
            isDownloadingAll = true
            isDownloadComplete = false
            downloadProgress = 0.0
            
            if isUpdate {
                showToast("🔄 Updating Pokédex...", type: .info)
            } else {
                showToast("📥 Downloading all 1300+ Pokémon...", type: .info)
            }
            
            // Small delay to ensure toast is visible
            try? await Task.sleep(for: .milliseconds(100))
            // Total pokedex has approximately <1400 Pokémon (as of Gen 9)
            let totalPokemon = 1400
            let batchSize = 100
            var downloadedCount = 0
            
            for batchOffset in stride(from: 0, to: totalPokemon, by: batchSize) {
                if Task.isCancelled { break }
                
                do {
                    let newPokemon = try await useCase.execute(offset: batchOffset, limit: batchSize)
                    
                    if newPokemon.isEmpty {
                        isDownloadingAll = false
                        downloadProgress = 1.0
                        isDownloadComplete = true
                        
                        currentOffset = 0
                        allPokemon = []
                        loadNextPage()
                        
                        if isUpdate {
                            showToast("✅ Pokédex updated! (\(downloadedCount) total)", type: .info)
                        } else {
                            showToast("✅ Pokémon downloaded!)", type: .info)
                        }
                        return
                    }
                    
                    downloadedCount += newPokemon.count
                    downloadProgress = min(1.0, Double(downloadedCount) / Double(totalPokemon))
                } catch {
                    print("Error downloading batch at offset \(batchOffset): \(error)")
                }

                
                // Small delay to avoid overwhelming the API
                try? await Task.sleep(for: .milliseconds(200))
            }
            
            isDownloadingAll = false
            downloadProgress = 1.0
            isDownloadComplete = true
            
            // Refresh the displayed list to show all downloaded Pokémon
            currentOffset = 0
            allPokemon = []
            loadNextPage()
            
            if isUpdate {
                showToast("✅ Update complete! \(downloadedCount) Pokémon cached", type: .info)
            } else {
                showToast("✅ Download complete! \(downloadedCount) Pokémon cached", type: .info)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func handleSuccessfulLoad(_ newPokemon: [Pokemon]) {
        if newPokemon.isEmpty {
            hasMorePages = false
        } else {
            // filter out dupes using Set - network might return same pokemon twice
            // specially during pagination boundries
            let existingIDs = Set(allPokemon.map(\.id))
            let uniqueNew = newPokemon.filter { !existingIDs.contains($0.id) }
            
            allPokemon.append(contentsOf: uniqueNew)
            currentOffset += pageSize
            
            // Apply filter to update displayed pokemon
            filterPokemon()
            
            // Show info toast on first load
            if currentOffset == pageSize && !uniqueNew.isEmpty {
                showToast("\(allPokemon.count) Pokémon ready to explore!", type: .info)
            }
        }
    }
    
    private func filterPokemon() {
        if searchText.isEmpty {
            pokemon = allPokemon
        } else {
            let lowercasedSearch = searchText.lowercased()
            pokemon = allPokemon.filter { pokemon in
                pokemon.name.lowercased().contains(lowercasedSearch) ||
                String(pokemon.id).contains(lowercasedSearch)
            }
        }
    }
    
    private func handleLoadError(_ error: Error) {
        // Only show error if we have no cached data
        if pokemon.isEmpty {
            showToast("Failed to load Pokemon: \(error.localizedDescription)", type: .error)
        } else {
            // We have cached data, show less intrusive warning
            showToast("Using cached data", type: .warning)
        }
    }
    
    private func showToast(_ message: String, type: ToastType) {
        toastMessage = message
        toastType = type
        
        // Auto-dismiss after 3 seconds
        Task {
            try? await Task.sleep(for: .seconds(3))
            if toastMessage == message {
                toastMessage = nil
            }
        }
    }
    
    private func checkDownloadStatus() async {
        let count = await repository.getCachedPokemonCount()
        // Consider download complete if we have more than 1000 Pokemon cached
        // This threshold indicates a full or near-full download
        isDownloadComplete = count > 1000
    }
}

// MARK: - Supporting Types

enum ToastType {
    case error, warning, info
}
