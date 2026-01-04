//
//  FavoritesView.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 29/12/25.
//

import SwiftUI

struct FavoritesView: View {
    @State var viewModel: FavoritesViewModel
    let dependencyContainer: DependencyContainer
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.favoritePokemon.isEmpty {
                    ContentUnavailableView(
                        "No Favorites",
                        systemImage: "star.slash",
                        description: Text("Mark Pokémon as favorites to see them here")
                    )
                } else {
                    List {
                        ForEach(viewModel.favoritePokemon) { pokemon in
                            NavigationLink(value: pokemon) {
                                PokemonListCell(pokemon: pokemon)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.removeFavorite(pokemon)
                                } label: {
                                    Label("Remove", systemImage: "star.slash.fill")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favorites")
            .navigationDestination(for: Pokemon.self) { pokemon in
                PokemonDetailView(
                    viewModel: dependencyContainer.makePokemonDetailViewModel(pokemonID: pokemon.id)
                )
            }
            .refreshable {
                viewModel.refresh()
            }
            .task {
                viewModel.loadFavorites()
            }
        }
    }
}

#Preview("Favorites - Empty") {
    @Previewable @State var viewModel = FavoritesViewModel(repository: MockFavoritesRepository.empty)
    
    FavoritesView(viewModel: viewModel, dependencyContainer: PreviewDependencyContainer.shared)
}

#Preview("Favorites - With Pokemon") {
    @Previewable @State var viewModel = FavoritesViewModel(repository: MockFavoritesRepository.withFavorites)
    
    FavoritesView(viewModel: viewModel, dependencyContainer: PreviewDependencyContainer.shared)
}


private final class MockFavoritesRepository: PokemonRepositoryProtocol {
    let mockFavorites: [Pokemon]
    
    init(favorites: [Pokemon] = []) {
        self.mockFavorites = favorites
    }
    
    static var empty: MockFavoritesRepository {
        MockFavoritesRepository()
    }
    
    static var withFavorites: MockFavoritesRepository {
        MockFavoritesRepository(favorites: [
            Pokemon(
                id: 25,
                name: "pikachu",
                spriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"),
                types: [PokemonType(name: "electric")],
                isFavorite: true
            ),
            Pokemon(
                id: 6,
                name: "charizard",
                spriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/6.png"),
                types: [PokemonType(name: "fire"), PokemonType(name: "flying")],
                isFavorite: true
            ),
            Pokemon(
                id: 9,
                name: "blastoise",
                spriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/9.png"),
                types: [PokemonType(name: "water")],
                isFavorite: true
            )
        ])
    }
    
    func fetchPokemonList(offset: Int, limit: Int) async throws -> [Pokemon] { [] }
    
    func fetchPokemonDetail(id: Int) async throws -> PokemonDetail {
        PokemonDetail(
            id: id,
            name: "preview",
            height: 7,
            weight: 69,
            stats: [],
            types: [],
            sprites: PokemonSprite(frontDefault: nil, frontShiny: nil, backDefault: nil, backShiny: nil)
        )
    }
    
    func toggleFavorite(id: Int) async -> Bool { true }
    func isFavorite(id: Int) async -> Bool { mockFavorites.contains { $0.id == id } }
    func getFavorites() async -> [Pokemon] { mockFavorites }
    func getCachedPokemonCount() async -> Int { 0 }
}
