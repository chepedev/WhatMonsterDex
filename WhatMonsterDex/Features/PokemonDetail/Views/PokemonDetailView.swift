//
//  PokemonDetailView.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 29/12/25.
//

import SwiftUI
import Kingfisher

struct PokemonDetailView: View {
    @State var viewModel: PokemonDetailViewModel
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.pokemonDetail == nil {
                loadingView
            } else if let error = viewModel.error, viewModel.pokemonDetail == nil {
                errorView(error)
            } else if let detail = viewModel.pokemonDetail {
                detailContent(detail)
            }
        }
        .navigationTitle(viewModel.pokemonDetail?.name.capitalized ?? "Loading...")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.toggleFavorite) {
                    Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                        .foregroundColor(viewModel.isFavorite ? .yellow : .gray)
                }
                .accessibilityLabel(viewModel.isFavorite ? "Remove from favorites" : "Add to favorites")
            }
        }
        .task {
            viewModel.loadDetail()
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading Pokemon...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(_ error: Error) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Failed to Load")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(error.localizedDescription)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: viewModel.retry) {
                Label("Retry", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private func detailContent(_ detail: PokemonDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection(detail)
                typesSection(detail)
                physicalAttributesSection(detail)
                statsSection(detail)
            }
            .padding()
        }
    }
    
    private func headerSection(_ detail: PokemonDetail) -> some View {
        VStack(spacing: 16) {
            KFImage(detail.sprites.frontDefault)
                .placeholder {
                    ProgressView()
                }
                .onFailure { _ in }
                .retry(maxCount: 1, interval: .seconds(1))
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .accessibilityLabel("Large sprite of \(detail.name)")
            
            Text(detail.name.capitalized)
                .font(.largeTitle)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
            
            Text("#\(detail.id)")
                .font(.title3)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func typesSection(_ detail: PokemonDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Types")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            
            HStack(spacing: 8) {
                ForEach(detail.types, id: \.name) { type in
                    TypeBadge(type: type)
                }
            }
        }
    }
    
    private func physicalAttributesSection(_ detail: PokemonDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Physical Attributes")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            
            HStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Height")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.1f m", detail.heightInMeters))
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Height: \(String(format: "%.1f meters", detail.heightInMeters))")
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Weight")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.1f kg", detail.weightInKilograms))
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Weight: \(String(format: "%.1f kilograms", detail.weightInKilograms))")
            }
        }
    }
    
    private func statsSection(_ detail: PokemonDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Base Stats")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            
            ForEach(detail.stats, id: \.name) { stat in
                StatRow(stat: stat)
            }
        }
    }
}

#Preview("Pikachu") {
    NavigationStack {
        PokemonDetailView(viewModel: .previewPikachu)
    }
}

#Preview("Charizard") {
    NavigationStack {
        PokemonDetailView(viewModel: .previewCharizard)
    }
}

extension PokemonDetailViewModel {
    @MainActor
    static var previewPikachu: PokemonDetailViewModel {
        let detail = PokemonDetail(
            id: 25,
            name: "pikachu",
            height: 4,
            weight: 60,
            stats: [
                Stat(name: "hp", baseStat: 35, effort: 0),
                Stat(name: "attack", baseStat: 55, effort: 0),
                Stat(name: "defense", baseStat: 40, effort: 0),
                Stat(name: "special-attack", baseStat: 50, effort: 0),
                Stat(name: "special-defense", baseStat: 50, effort: 0),
                Stat(name: "speed", baseStat: 90, effort: 2)
            ],
            types: [PokemonType(name: "electric")],
            sprites: PokemonSprite(
                frontDefault: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"),
                frontShiny: nil,
                backDefault: nil,
                backShiny: nil
            )
        )
        
        let repo = PreviewRepository(detail: detail)
        let useCase = FetchPokemonDetailUseCase(repository: repo)
        let vm = PokemonDetailViewModel(pokemonID: 25, useCase: useCase, repository: repo)
        
        // Trigger immediate load for preview
        Task { @MainActor in
            vm.loadDetail()
        }
        
        return vm
    }
    
    @MainActor
    static var previewCharizard: PokemonDetailViewModel {
        let detail = PokemonDetail(
            id: 6,
            name: "charizard",
            height: 17,
            weight: 905,
            stats: [
                Stat(name: "hp", baseStat: 78, effort: 0),
                Stat(name: "attack", baseStat: 84, effort: 0),
                Stat(name: "defense", baseStat: 78, effort: 0),
                Stat(name: "special-attack", baseStat: 109, effort: 3),
                Stat(name: "special-defense", baseStat: 85, effort: 0),
                Stat(name: "speed", baseStat: 100, effort: 0)
            ],
            types: [PokemonType(name: "fire"), PokemonType(name: "flying")],
            sprites: PokemonSprite(
                frontDefault: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/6.png"),
                frontShiny: nil,
                backDefault: nil,
                backShiny: nil
            )
        )
        
        let repo = PreviewRepository(detail: detail)
        let useCase = FetchPokemonDetailUseCase(repository: repo)
        let vm = PokemonDetailViewModel(pokemonID: 6, useCase: useCase, repository: repo)
        
        // Trigger immediate load for preview
        Task { @MainActor in
            vm.loadDetail()
        }
        
        return vm
    }
}

private final class PreviewRepository: PokemonRepositoryProtocol {
    let detail: PokemonDetail
    
    init(detail: PokemonDetail) {
        self.detail = detail
    }
    
    func fetchPokemonList(offset: Int, limit: Int) async throws -> [Pokemon] { [] }
    func fetchPokemonDetail(id: Int) async throws -> PokemonDetail { detail }
    func toggleFavorite(id: Int) async -> Bool { false }
    func isFavorite(id: Int) async -> Bool { false }
    func getFavorites() async -> [Pokemon] { [] }
    func getCachedPokemonCount() async -> Int { 0 }
}
