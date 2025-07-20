# Minimal PONG - Swift App

A clean, minimalist implementation of the classic Pong game for macOS and iOS, inspired by BRAUN and Otl Aicher design principles.

![Minimal PONG](https://via.placeholder.com/800x400/F8F8F8/1A1A1A?text=MINIMAL+PONG)

## Design Philosophy

This app embodies the principles of functional minimalism:
- **Monochrome Palette**: Clean blacks, whites, and grays
- **Geometric Precision**: Simple, exact shapes using SpriteKit
- **Functional Typography**: SF Pro Display for clarity and readability  
- **No Decoration**: Every element serves a purpose
- **Platform Native**: SwiftUI interface with SpriteKit game engine

## Features

### Gameplay
- 🎮 **Two-player local gameplay** (keyboard on Mac, touch controls on iOS)
- 🤖 **AI opponent mode** with balanced difficulty
- 🎯 **Physics-based ball collision** with realistic angle deflection
- 📊 **Real-time score tracking** and rally counter
- ⚡ **Dynamic game speed** that increases with rally length
- 🎵 **Minimalist sound effects** with haptic feedback on iOS

### Cross-Platform Support
- 📱 **iOS**: Touch controls with intuitive paddle buttons
- 💻 **macOS**: Keyboard controls (W/S and ↑/↓ arrows)
- 🎨 **Responsive Design**: Adapts to different screen sizes
- 🌗 **Light theme**: Enforced Braun aesthetic

### Game Options
- **Configurable winning scores**: 5, 10, or 15 points
- **Game modes**: Two-player or vs AI
- **Pause/Resume functionality**
- **Particle effects** for visual feedback

## Requirements

### Development
- **Xcode 15.0+**
- **iOS 17.0+** / **macOS 14.0+**
- **Swift 5.9+**

### Runtime
- iOS device or simulator running iOS 17.0+
- Mac running macOS 14.0+

## Installation & Building

### Option 1: Xcode
1. Open `MinimalPong.xcodeproj` in Xcode
2. Select your target device/simulator
3. Press `Cmd+R` to build and run

### Option 2: Command Line
```bash
# Navigate to project directory
cd MinimalPong

# Build for iOS Simulator
xcodebuild -project MinimalPong.xcodeproj -scheme MinimalPong -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 15'

# Build for macOS
xcodebuild -project MinimalPong.xcodeproj -scheme MinimalPong -sdk macosx
```

## How to Play

### macOS Controls
- **Player 1** (Left paddle): `W` (up) and `S` (down)
- **Player 2** (Right paddle): `↑` and `↓` arrow keys
- **Pause/Resume**: `P` key
- **Start game**: `Space` bar (on start screen)

### iOS Controls
- **Touch controls**: Tap and hold the arrow buttons for each paddle
- **Two-player mode**: Each player controls their respective paddle buttons
- **AI mode**: You control the left paddle, AI controls the right

### Game Rules
- First player to reach the target score wins
- Ball speed increases every 5 rally hits
- Ball angle changes based on where it hits the paddle
- Rally counter resets after each point

## Project Structure

```
MinimalPong/
├── MinimalPong.xcodeproj/          # Xcode project file
├── MinimalPong/
│   ├── MinimalPongApp.swift        # App entry point
│   ├── ContentView.swift           # Main view container
│   ├── GameView.swift              # Game UI and screens
│   ├── GameScene.swift             # SpriteKit game logic
│   ├── GameState.swift             # Game state management
│   ├── SoundManager.swift          # Audio effects
│   ├── Assets.xcassets/            # App icons and colors
│   ├── MinimalPong.entitlements    # App permissions
│   └── Preview Content/            # SwiftUI preview assets
└── README.md                       # This file
```

## Architecture

### SwiftUI + SpriteKit Hybrid
- **SwiftUI**: Handles UI, menus, and game state
- **SpriteKit**: Manages game physics, rendering, and input
- **ObservableObject**: Reactive game state management
- **Cross-platform**: Single codebase for iOS and macOS

### Key Components
- **GameState**: Central state management with `@Published` properties
- **GameScene**: SpriteKit scene handling physics and rendering
- **SoundManager**: Audio engine for procedural sound effects
- **Platform-specific**: Conditional compilation for iOS/macOS differences

## Design Inspiration

Inspired by the design philosophies of:
- **Dieter Rams** and BRAUN's functional design principles
- **Otl Aicher's** systematic approach to visual communication
- **Swiss Design** movement emphasizing clarity and precision
- **Apple's Human Interface Guidelines** for native platform feel

## Technical Details

### Performance
- **60fps gameplay** using SpriteKit's optimized rendering
- **Efficient particle system** for visual effects
- **Minimal memory footprint** with object pooling
- **Battery-optimized** with appropriate frame rate management

### Audio
- **Procedural sound synthesis** using AVAudioEngine
- **No external audio files** - sounds generated mathematically
- **iOS haptic feedback** integration
- **Ambient audio category** for background app compatibility

## License

MIT License - Feel free to use and modify as needed.

## Contributing

This project maintains the original minimal design aesthetic. When contributing:
1. Preserve the monochrome color palette
2. Use only SF Pro Display font family
3. Maintain clean, functional UI elements
4. Test on both iOS and macOS platforms

---

*Created with attention to functional design and clean aesthetics, following the Braun design tradition.*