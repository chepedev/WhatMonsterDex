//
//  PokemonListView.swift
//  WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 28/12/25.
//

import SwiftUI

struct PokemonListView: View { 
    @State var viewModel: PokemonListViewModel
    let dependencyContainer: DependencyContainer
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.pokemon) { pokemon in
                        NavigationLink(value: pokemon) {
                            PokemonListCell(pokemon: pokemon)
                                .onAppear {
                                    if viewModel.shouldLoadMore(currentItem: pokemon) {
                                        viewModel.loadNextPage()
                                    }
                                }
                        }
                    }
                    
                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .padding()
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Pokémon")
                .searchable(
                    text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search by name or ID"
                )
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if viewModel.isDownloadingAll {
                            HStack(spacing: 8) {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("\(Int(viewModel.downloadProgress * 100))%")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        } else if viewModel.isDownloadComplete {
                            Button(action: viewModel.downloadAllPokemon) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        } else {
                            Menu {
                                Button(action: viewModel.downloadAllPokemon) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Download All Pokédex")
                                            .font(.body)
                                        Text("(1300+ Pokémon)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Image(systemName: "arrow.down.circle.fill")
                                }
                            } label: {
                                Image(systemName: "arrow.down.circle.fill")
                            }
                        }
                    }
                }
                .navigationDestination(for: Pokemon.self) { pokemon in
                    PokemonDetailView(
                        viewModel: dependencyContainer.makePokemonDetailViewModel(pokemonID: pokemon.id)
                    )
                }
                .refreshable {
                    viewModel.refresh()
                }
                .task {
                    viewModel.loadNextPage()
                }
                
                if let message = viewModel.toastMessage {
                    VStack {
                        Spacer()
                        ToastView(message: message, type: viewModel.toastType)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .animation(.spring(), value: viewModel.toastMessage)
                            .onTapGesture {
                                viewModel.dismissToast()
                            }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview("Pokemon List") {
    @Previewable @State var viewModel = PokemonListViewModel(
        useCase: FetchPokemonListUseCase(repository: MockPokemonListRepository.withPokemon),
        repository: MockPokemonListRepository.withPokemon
    )
    
    PokemonListView(viewModel: viewModel, dependencyContainer: PreviewDependencyContainer.shared)
}
// Mock ups

private final class MockPokemonListRepository: PokemonRepositoryProtocol {
    let mockPokemon: [Pokemon]
    
    init(pokemon: [Pokemon] = []) {
        self.mockPokemon = pokemon
    }
    
    static var withPokemon: MockPokemonListRepository {
        MockPokemonListRepository(pokemon: [
            Pokemon(
                id: 1,
                name: "bulbasaur",
                spriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"),
                types: [PokemonType(name: "grass"), PokemonType(name: "poison")]
            ),
            Pokemon(
                id: 4,
                name: "charmander",
                spriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png"),
                types: [PokemonType(name: "fire")]
            ),
            Pokemon(
                id: 7,
                name: "squirtle",
                spriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png"),
                types: [PokemonType(name: "water")]
            ),
            Pokemon(
                id: 25,
                name: "pikachu",
                spriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"),
                types: [PokemonType(name: "electric")]
            )
        ])
    }
    
    func fetchPokemonList(offset: Int, limit: Int) async throws -> [Pokemon] { mockPokemon }
    
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
    
    func toggleFavorite(id: Int) async -> Bool { false }
    func isFavorite(id: Int) async -> Bool { false }
    func getFavorites() async -> [Pokemon] { [] }
    func getCachedPokemonCount() async -> Int { 0 }
}
