import SwiftUI
import SpriteKit

struct GameView: View {
    @EnvironmentObject var gameState: GameState
    @State private var scene: GameScene?
    
    var body: some View {
        ZStack {
            // Game Canvas
            if let scene = scene {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
            }
            
            // Score Display
            if gameState.currentScreen == .playing {
                VStack {
                    HStack {
                        Spacer()
                        Text("\(gameState.leftScore) — \(gameState.rightScore)")
                            .font(.custom("SF Pro Display", size: 32))
                            .fontWeight(.light)
                            .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                            .tracking(3)
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // Game Stats
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Speed: \(String(format: "%.1f", gameState.gameSpeed))x")
                            Text("Rally: \(gameState.rally)")
                        }
                        .font(.custom("SF Pro Display", size: 12))
                        .fontWeight(.light)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .tracking(0.5)
                        .padding(.leading, 20)
                        .padding(.bottom, 20)
                        
                        Spacer()
                        
                        #if os(iOS)
                        // Touch controls for iOS
                        HStack(spacing: 20) {
                            VStack(spacing: 10) {
                                TouchButton(isPressed: $gameState.leftPaddleUp, label: "↑")
                                TouchButton(isPressed: $gameState.leftPaddleDown, label: "↓")
                            }
                            Spacer()
                            VStack(spacing: 10) {
                                TouchButton(isPressed: $gameState.rightPaddleUp, label: "↑")
                                TouchButton(isPressed: $gameState.rightPaddleDown, label: "↓")
                            }
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                        #endif
                    }
                }
            }
            
            // Start Screen
            if gameState.currentScreen == .start {
                StartScreen()
            }
            
            // Pause Screen
            if gameState.currentScreen == .paused {
                PauseScreen()
            }
            
            // Game Over Screen
            if gameState.currentScreen == .gameOver {
                GameOverScreen()
            }
        }
        .onAppear {
            setupScene()
        }
        #if os(macOS)
        .onKeyPress(.space) {
            if gameState.currentScreen == .start {
                gameState.startGame()
            }
            return .handled
        }
        .onKeyPress(KeyEquivalent("p")) {
            if gameState.currentScreen == .playing {
                gameState.pauseGame()
            } else if gameState.currentScreen == .paused {
                gameState.resumeGame()
            }
            return .handled
        }
        #endif
    }
    
    private func setupScene() {
        let newScene = GameScene()
        newScene.gameState = gameState
        newScene.scaleMode = .aspectFit
        scene = newScene
    }
}

struct StartScreen: View {
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.95)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("PONG")
                    .font(.custom("SF Pro Display", size: 48))
                    .fontWeight(.light)
                    .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .tracking(8)
                
                VStack(spacing: 20) {
                    Text("Game Mode")
                        .font(.custom("SF Pro Display", size: 14))
                        .fontWeight(.regular)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .tracking(0.5)
                    
                    HStack(spacing: 16) {
                        GameButton(
                            title: "Two Player",
                            isSelected: gameState.gameMode == .twoPlayer
                        ) {
                            gameState.gameMode = .twoPlayer
                        }
                        
                        GameButton(
                            title: "vs AI",
                            isSelected: gameState.gameMode == .ai
                        ) {
                            gameState.gameMode = .ai
                        }
                    }
                }
                
                VStack(spacing: 20) {
                    Text("First to Score")
                        .font(.custom("SF Pro Display", size: 14))
                        .fontWeight(.regular)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .tracking(0.5)
                    
                    HStack(spacing: 16) {
                        GameButton(
                            title: "5",
                            isSelected: gameState.winningScore == 5
                        ) {
                            gameState.winningScore = 5
                        }
                        
                        GameButton(
                            title: "10",
                            isSelected: gameState.winningScore == 10
                        ) {
                            gameState.winningScore = 10
                        }
                        
                        GameButton(
                            title: "15",
                            isSelected: gameState.winningScore == 15
                        ) {
                            gameState.winningScore = 15
                        }
                    }
                }
                
                Button(action: {
                    gameState.startGame()
                }) {
                    Text("START GAME")
                        .font(.custom("SF Pro Display", size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .tracking(1.5)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                }
                .buttonStyle(.plain)
                
                #if os(macOS)
                VStack(spacing: 4) {
                    Text("Player 1: W / S")
                    Text("Player 2: ↑ / ↓")
                    Text("Press P to pause")
                }
                .font(.custom("SF Pro Display", size: 12))
                .fontWeight(.light)
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                .tracking(0.5)
                #endif
            }
        }
    }
}

struct PauseScreen: View {
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("PAUSED")
                    .font(.custom("SF Pro Display", size: 48))
                    .fontWeight(.light)
                    .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .tracking(8)
                
                VStack(spacing: 16) {
                    Button(action: {
                        gameState.resumeGame()
                    }) {
                        Text("RESUME")
                            .font(.custom("SF Pro Display", size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .tracking(1.5)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        gameState.showMenu()
                    }) {
                        Text("RESTART")
                            .font(.custom("SF Pro Display", size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                            .tracking(1.5)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 0)
                                    .stroke(Color(red: 0.88, green: 0.88, blue: 0.88), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct GameOverScreen: View {
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.95)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text(gameState.winner)
                    .font(.custom("SF Pro Display", size: 32))
                    .fontWeight(.light)
                    .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .tracking(3)
                
                VStack(spacing: 16) {
                    Button(action: {
                        gameState.startGame()
                    }) {
                        Text("PLAY AGAIN")
                            .font(.custom("SF Pro Display", size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .tracking(1.5)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        gameState.showMenu()
                    }) {
                        Text("MENU")
                            .font(.custom("SF Pro Display", size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                            .tracking(1.5)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 0)
                                    .stroke(Color(red: 0.88, green: 0.88, blue: 0.88), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct GameButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title.uppercased())
                .font(.custom("SF Pro Display", size: 16))
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : Color(red: 0.1, green: 0.1, blue: 0.1))
                .tracking(1.5)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(isSelected ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color(red: 0.88, green: 0.88, blue: 0.88), lineWidth: isSelected ? 0 : 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#if os(iOS)
struct TouchButton: View {
    @Binding var isPressed: Bool
    let label: String
    
    var body: some View {
        Text(label)
            .font(.system(size: 24, weight: .light))
            .foregroundColor(isPressed ? .white : Color(red: 0.1, green: 0.1, blue: 0.1))
            .frame(width: 50, height: 50)
            .background(isPressed ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color(red: 0.88, green: 0.88, blue: 0.88), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                isPressed = pressing
            }, perform: {})
    }
}
#endif

#Preview {
    GameView()
        .environmentObject(GameState())
}