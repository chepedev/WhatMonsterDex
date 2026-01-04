//
//  InfoView.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 30/12/25.
//

import SwiftUI
import Kingfisher

struct InfoView: View {
    @State var viewModel: InfoViewModel
    @State private var showTechnicalDetails = false
    @State private var showingClearAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    appInfoSection
                    
                    Divider()
                        .padding(.horizontal)
                    
                    storageSection
                    
                    Divider()
                        .padding(.horizontal)
                    
                    developerSection
                    
                    Divider()
                        .padding(.horizontal)
                    
                    contactSection
                    
                    Divider()
                        .padding(.horizontal)
                    
                    technicalDetailsSection
                }
                .padding()
            }
            .navigationTitle("Info")
            .task {
                viewModel.calculateStorageSize()
            }
            .alert("Clear All Data?", isPresented: $showingClearAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    viewModel.clearAllData()
                }
            } message: {
                Text("This will delete all cached Pokémon data and images. You'll need to download them again.")
            }
        }
    }
    
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundStyle(.blue.gradient)
            
            Text("What is WhatMonsterDex?")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Your pocket-sized Pokédex companion! Browse through all your favorite Pokémon, search by name or ID, and mark your favorites for quick access.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                FeatureRow(icon: "magnifyingglass", text: "Search Pokémon by name or ID")
                FeatureRow(icon: "star.fill", text: "Save your favorites")
                FeatureRow(icon: "wifi.slash", text: "Works offline with cached data")
                FeatureRow(icon: "photo", text: "High-quality Pokémon sprites")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    
    private var storageSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "internaldrive.fill")
                    .font(.title2)
                    .foregroundColor(.purple)
                Text("Storage")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cached Pokémon")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(viewModel.pokemonCount)")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Storage Used")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(viewModel.storageSize)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                .padding()
                .background(Color.purple.opacity(0.1))
                .cornerRadius(12)
                
                Button(action: { showingClearAlert = true }) {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("Clear All Cached Data")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.gradient)
                    .cornerRadius(12)
                }
            }
        }
    }
        
    private var developerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.orange.gradient)
            
            Text("Meet the Developer")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Jose Chirinos")
                .font(.title3)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                InfoCard(icon: "iphone", title: "Mobile Developer", description: "Crafting delightful iOS experiences")
                
                InfoCard(icon: "motorcycle.fill", title: "Motorcycle Enthusiast", description: "Two wheels, endless adventures 🏍️")
                
                InfoCard(icon: "swift", title: "SwiftUI Wizard", description: "Building apps with modern Swift")
            }
            
            Text("💡 Fun Fact")
                .font(.headline)
                .padding(.top, 8)
            
            Text("This app was built with SwiftUI, Clean Architecture, and a lot of ☕️. If you're looking for someone who can turn caffeine into code while dreaming about the open road, you've found your guy!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .italic()
        }
    }
        
    private var contactSection: some View {
        VStack(spacing: 16) {
            Text("Let's Connect!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Got a cool project idea? Want to chat about motorcycles or mobile development? Don't be shy!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Link(destination: URL(string: "https://codewithjose.com")!) {
                HStack {
                    Image(systemName: "globe")
                        .font(.title3)
                    Text("codewithjose.com")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.gradient)
                .cornerRadius(12)
            }
            .padding(.horizontal)
            
            Text("🚀 Always open to new opportunities and collaborations!")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 8)
        }
    }
    
    // MARK: - Technical Details Section
    
    private var technicalDetailsSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                withAnimation {
                    showTechnicalDetails.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "gearshape.2.fill")
                        .foregroundColor(.gray)
                    Text("Technical Details")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: showTechnicalDetails ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            
            if showTechnicalDetails {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "building.columns.fill")
                                .foregroundColor(.blue)
                            Text("Architecture")
                                .font(.headline)
                        }
                        
                        Text("This app was built as a demonstration of modern iOS development practices, featuring:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            TechPoint(text: "MVVM (Model-View-ViewModel) pattern")
                            TechPoint(text: "Clean Architecture principles")
                            TechPoint(text: "Swift 6 concurrency with async/await")
                            TechPoint(text: "SwiftData for local persistence")
                            TechPoint(text: "Offline-first approach")
                        }
                        .padding(.leading, 8)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "server.rack")
                                .foregroundColor(.green)
                            Text("Data Source")
                                .font(.headline)
                        }
                        
                        Text("All Pokémon data is provided by:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Link(destination: URL(string: "https://pokeapi.co")!) {
                            HStack {
                                Image(systemName: "link")
                                Text("PokéAPI")
                                    .fontWeight(.semibold)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                            }
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(8)
                        }
                        
                        Text("PokéAPI is a free and open RESTful API for Pokémon data. This app is not affiliated with or endorsed by The Pokémon Company, Nintendo, or Game Freak.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.orange)
                            Text("Attribution")
                                .font(.headline)
                        }
                        
                        Text("Pokémon and Pokémon character names are trademarks of Nintendo. This is a fan-made educational project created to demonstrate iOS development skills.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("All Pokémon data and images are © Nintendo/Creatures Inc./GAME FREAK inc.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

// MARK: - Supporting Views

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
    }
}

struct InfoCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct TechPoint: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.blue)
                .font(.caption)
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Previews

#Preview("Info View") {
    @Previewable @State var viewModel = InfoViewModel(dataActor: PreviewDataActor.shared)
    
    InfoView(viewModel: viewModel)
}

#Preview("Feature Row") {
    VStack(spacing: 8) {
        FeatureRow(icon: "magnifyingglass", text: "Search Pokémon by name or ID")
        FeatureRow(icon: "star.fill", text: "Save your favorites")
        FeatureRow(icon: "wifi.slash", text: "Works offline with cached data")
        FeatureRow(icon: "photo", text: "High-quality Pokémon sprites")
    }
    .padding()
}

#Preview("Info Card") {
    VStack(spacing: 12) {
        InfoCard(icon: "iphone", title: "Mobile Developer", description: "Crafting delightful iOS experiences")
        InfoCard(icon: "motorcycle.fill", title: "Motorcycle Enthusiast", description: "Two wheels, endless adventures 🏍️")
        InfoCard(icon: "swift", title: "SwiftUI Wizard", description: "Building apps with modern Swift")
    }
    .padding()
}

#Preview("Tech Point") {
    VStack(alignment: .leading, spacing: 6) {
        TechPoint(text: "MVVM (Model-View-ViewModel) pattern")
        TechPoint(text: "Clean Architecture principles")
        TechPoint(text: "Swift 6 concurrency with async/await")
        TechPoint(text: "SwiftData for local persistence")
        TechPoint(text: "Offline-first approach")
    }
    .padding()
}

// MARK: - Preview Helpers

private final class PreviewDataActor {
    static let shared = PokemonDataActor(modelContainer: PreviewModelContainer.shared)
}
