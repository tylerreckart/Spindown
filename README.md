# Spindown

A modern, feature-rich life tracking companion app for Magic: The Gathering.

## About

Spindown is a native iOS app designed to enhance your Magic: The Gathering gameplay experience. Built with SwiftUI, it provides an intuitive and visually appealing interface for tracking life totals, counters, and game state across multiple players.

## Features

### Core Functionality
- **Life Total Tracking**: Precise life total management for 2-6 players
- **Multiple Counter Types**: Track poison, energy, experience, and ticket counters
- **Dynamic Game Boards**: Optimized layouts for different player counts
- **Game Timer**: Built-in timer with customizable alerts
- **Starting Player Selection**: Random starting player selection with visual feedback

### User Experience
- **Dark Mode Interface**: Sleek, eye-friendly dark theme optimized for gaming
- **Haptic Feedback**: Tactile responses for better user interaction
- **Adaptive Layouts**: Portrait and landscape orientations with rotation support
- **Player Customization**: Personalized player names and color schemes
- **Life Total Calculator**: Built-in calculator for complex life changes

### Advanced Features
- **Saved Players**: Store and reuse player configurations (Premium)
- **Magic Rules Database**: Complete searchable rules reference (100-900 series)
- **Subscription Management**: In-app purchases with StoreKit integration
- **Core Data Persistence**: Reliable data storage and retrieval

## Technical Architecture

### Built With
- **SwiftUI**: Modern declarative UI framework
- **Core Data**: Local data persistence
- **StoreKit**: In-app purchase management
- **HappyPath**: Review management integration
- **Xcode 15+**: Latest iOS development tools

### Project Structure
```
Spindown/
├── Models/
│   ├── Participant.swift      # Player data model
│   ├── Store.swift           # StoreKit integration
│   ├── Timer.swift           # Game timer logic
│   └── HapticsManager.swift  # Haptic feedback
├── Views/
│   ├── ContentView.swift     # Main app coordinator
│   ├── GameBoard/           # Game board layouts
│   └── Onboarding/          # Setup flow
├── Components/
│   ├── PlayerTile.swift     # Individual player UI
│   ├── Dialogs/            # Modal interfaces
│   └── Buttons/            # Custom UI elements
├── Controllers/
│   └── Persistence.swift   # Core Data stack
└── Constants/
    └── Rules/              # Magic rules database
```

### Key Components

#### Game State Management
The app uses a reactive architecture with `@StateObject` and `@ObservableObject` to manage game state:
- Player life totals and counters
- Game timer state
- Active player tracking
- Board layout preferences

#### Player Management
Each player is represented by a `Participant` class with:
- Unique identifier (UUID)
- Life total tracking
- Counter management (poison, energy, experience, tickets)
- Color customization
- Reactive UI updates

#### Dynamic Layouts
The app automatically selects optimal board layouts based on player count:
- 2 players: Tandem or facing layouts
- 3 players: Triangle formation
- 4 players: Square grid
- 5-6 players: Optimized circular arrangements

## Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 16.0+ deployment target
- Valid Apple Developer account (for StoreKit testing)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/tylerreckart/spindown.git
cd spindown
```

2. Open the project in Xcode:
```bash
open Spindown.xcodeproj
```

3. Configure your development team in the project settings

4. Build and run on your device or simulator

### StoreKit Configuration

The app includes StoreKit configuration for subscription management:
- Yearly subscription: `com.spindown.plus.yearly` ($4.99/year)
- Monthly subscriptions available
- Free trial periods supported

To test subscriptions:
1. Configure StoreKit testing in Xcode
2. Use the included `Subscriptions.storekit` configuration
3. Test with sandbox Apple ID accounts

## Usage

### Starting a Game
1. Launch the app
2. Select starting life total (20, 30, 40, etc.)
3. Choose number of players (2-6)
4. Customize player names and colors (Premium)
5. Begin tracking!

### During Gameplay
- **Tap numbers** to adjust life totals
- **Swipe between counters** to track different types
- **Long press** for calculator input
- **Use timer** for timed matches
- **Access settings** via gear icon

### Rules Reference
The app includes a complete Magic: The Gathering rules database covering sections 100-900, searchable and organized for quick reference during games.

## License

This project is licensed under the MIT License.

## Acknowledgments

- Magic: The Gathering is a trademark of Wizards of the Coast LLC
- Built with love for the Magic community
- Special thanks to all beta testers and contributors

## Privacy

Spindown respects your privacy:
- No personal data collection
- Local data storage only
- Optional analytics (with consent)
- Subscription data handled securely via Apple

---

**Note**: This app is not affiliated with or endorsed by Wizards of the Coast LLC. Magic: The Gathering is a registered trademark of Wizards of the Coast LLC.
