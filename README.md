# 🐾 WhatPokemon

A modern iOS app for browsing and discovering Pokémon, built with SwiftUI and Clean Architecture.

> **📚 Educational Project**: This code is shared for learning purposes. You're welcome to study the architecture, patterns, and implementation details. However, please do not clone and deploy this app to the App Store, since this project will be released and deployed for others to see it live. See [LICENSE](LICENSE) for details.

This is an educational project, that demonstrates how to build a modern iOS app with SwiftUI, Clean Architecture + MVVM, and offline-first approach.
It is currently under AppStore review/deployment, once approved:  https://apps.apple.com/us/app/whatpokemon/id6757093052

<p align="center">
  <img src="https://img.shields.io/badge/iOS-26.2+-blue.svg" />
  <img src="https://img.shields.io/badge/Swift-6.2-orange.svg" />
  <img src="https://img.shields.io/badge/Xcode-26.2+-blue.svg" />
  <img src="https://img.shields.io/badge/License-ESL-green.svg" />
</p>

## ✨ Features

- 📱 **Browse All Pokémon**: Explore the complete Pokédex with infinite scroll pagination
- 🔍 **Detailed View**: View stats, types, sprites, and more for each Pokémon
- ⭐ **Favorites**: Mark your favorite Pokémon and access them quickly
- 💾 **Offline-First**: Cache-first architecture for instant loading, works completely offline
- 🎨 **Modern UI**: Beautiful SwiftUI with the new Glass effects :) (check the bottom nav bar)
- 🏗️ **Clean Architecture**: MVVM + Clean Architecture for maintainability
- 🧪 **Well Tested**: Written tests for all the layers of its architecture(Still it would be nice to add more)

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **MVVM** pattern, implementing an **offline-first** approach for optimal user experience.

### Architecture Layers

```
whatpokemon/
├── App/                 # Dependency injection container
├── Core/                # Shared infrastructure
│   ├── Networking/      # HTTP client, endpoints, error handling
│   ├── Storage/         # SwiftData actors, favorites manager
│   └── Utilities/       # Extensions, helpers, color utilities
├── Data/               # Data layer (implements Domain interfaces)
│   ├── DTOs/            # Network response models (Codable)
│   ├── Mappers/          # DTO ↔ Entity ↔ PersistentModel converters
│   ├── PersistentModels/ # SwiftData @Model classes
│   └── Repositories/     # Concrete repository implementations
├── Domain/               # Business logic layer (framework-independent)
│   ├── Entities/        # Core domain models (Pokemon, PokemonDetail, etc.)
│   ├── Interfaces/      # Repository protocols (dependency inversion)
│   └── UseCases/        # Business use cases (FetchPokemonList, etc.)
└── Features/            # Presentation layer (SwiftUI + ViewModels)
    ├── PokemonList/    # List screen with infinite scroll
    ├── PokemonDetail/  # Detail screen with stats and sprites
    ├── Favorites/      # Favorites management
    └── Info/            # About and storage management (UI)
```


### Key Technologies

- **SwiftUI**: Modern declarative UI framework
- **Swift 6.2**: Latest Swift with strict concurrency
- **SwiftData**: For local persistence with actor isolation
- **Async/Await**: Modern concurrency 
- **Actor Isolation**: Thread-safe data access
- **Kingfisher 8.6.2**: Image downloading and caching
- **MVVM**: Clear separation of concerns
- **Dependency Injection**: Testable architecture
- **Swift Testing**: Modern testing framework

## 🚀 Getting Started

### Prerequisites

- Xcode 26.2 or later
- iOS 26.2 or later
- macOS Tahoe 26.1 or later 

Everythig up to date with the latest version of Xcode and Swift as of Dec 2025.

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/whatpokemon.git
cd whatpokemon
```

2. Open the project:
```bash
open whatpokemon.xcodeproj
```
This project uses Swift Package Manager for dependencies, so no additional setup is required.

3. **Important**: Change the bundle identifier to your own:
   - Open project settings
   - Select the `whatpokemon` target
   - Change `Bundle Identifier` from `com.chepedeveloper.whatpokemon` to your own
   - Select your Development Team

4. Build and run (⌘R)

### Running Tests

Run all tests with:
```bash
xcodebuild test -scheme whatpokemon -destination 'platform=iOS Simulator,name=iPhone 17'
```

Or use Xcode's test navigator (⌘U)

## 📦 Dependencies

- [Kingfisher](https://github.com/onevcat/Kingfisher) (8.6.2) - Image downloading and caching

## 🌐 API

This app uses the free [PokéAPI](https://pokeapi.co/) - no API key required!

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the **Educational Source License (ESL)** - see the [LICENSE](LICENSE) file for details.

**TL;DR:**
- ✅ Study and learn from the code
- ✅ Use patterns and snippets in your own projects
- ✅ Fork for personal learning
- ❌ Do NOT deploy to App Store
- ❌ Do NOT rebrand and republish


This projects consumes an open API to fetch Pokemon data, and they state a fair use: https://pokeapi.co/docs/v2, 
reason why I am not monetizing the app at all, again this is for EDUCATIONAL purposes only.

## 👨‍💻 Author

**Jose Chirinos**
- Website: [codewithjose.com](https://codewithjose.com)
- Mobile Developer & Motorcycle Enthusiast 🏍️

## 🙏 Acknowledgments

- [PokéAPI](https://pokeapi.co/) for the amazing free API
- [Kingfisher](https://github.com/onevcat/Kingfisher) for excellent image handling and caching

---

Made with ☕️ and SwiftUI
