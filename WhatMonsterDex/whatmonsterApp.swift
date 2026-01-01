//
// WhatMonsterDexApp.swift
// WhatMonsterDex
//
//  Created by Jose Chirinos Odio on 26/12/25.
//

import SwiftUI
import SwiftData

@main
struct WhatMonsterDex: App {
    let container: ModelContainer
    let dependencyContainer: DependencyContainer
    
    init() {
        do {
            let schema = Schema([
                PokemonPersistentModel.self,
                PokemonDetailPersistentModel.self
            ])
            
            let configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                allowsSave: true
            )
            
            container = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
            
            dependencyContainer = DependencyContainer(modelContainer: container)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                PokemonListView(
                    viewModel: dependencyContainer.makePokemonListViewModel(),
                    dependencyContainer: dependencyContainer
                )
                .tabItem {
                    Label("Pokémon", systemImage: "list.bullet")
                }
                
                FavoritesView(
                    viewModel: dependencyContainer.makeFavoritesViewModel(),
                    dependencyContainer: dependencyContainer
                )
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
                
                InfoView(viewModel: dependencyContainer.makeInfoViewModel())
                    .tabItem {
                        Label("Info", systemImage: "info.circle.fill")
                    }
            }
        }
        .modelContainer(container)
    }
}
