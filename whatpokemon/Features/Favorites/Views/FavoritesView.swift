//
//  FavoritesView.swift
//  whatpokemon
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
