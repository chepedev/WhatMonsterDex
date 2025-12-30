//
//  PokemonDetailView.swift
//  whatpokemon
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
    
    // MARK: - Loading View
    
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
    
    // MARK: - Error View
    
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
    
    // MARK: - Detail Content
    
    private func detailContent(_ detail: PokemonDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header with sprite
                headerSection(detail)
                
                // Types
                typesSection(detail)
                
                // Physical attributes
                physicalAttributesSection(detail)
                
                // Stats
                statsSection(detail)
            }
            .padding()
        }
    }
    
    // MARK: - Header Section
    
    private func headerSection(_ detail: PokemonDetail) -> some View {
        VStack(spacing: 16) {
            KFImage(detail.sprites.frontDefault)
                .placeholder {
                    ProgressView()
                }
                .onFailure { _ in
                    // Silently handle image load failures
                }
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
    
    // MARK: - Types Section
    
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
    
    // MARK: - Physical Attributes Section
    
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
    
    // MARK: - Stats Section
    
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
