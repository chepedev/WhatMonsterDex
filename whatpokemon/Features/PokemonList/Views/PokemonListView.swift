//
//  PokemonListView.swift
//  whatpokemon
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
                
                // Toast overlay
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
